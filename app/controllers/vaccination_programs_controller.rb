# frozen_string_literal: true

class VaccinationProgramsController < ApplicationController
  def index
    @vaccination_programs = current_user.vaccination_programs
    if @vaccination_programs
      render json: { vaccinationPrograms: @vaccination_programs }
    else
      render status: 500, json: { errors: ['No Vaccination programs found'] }
    end
  end

  def show
    @vaccination_program = VaccinationProgram.find(params[:id])
    if @vaccination_program && @vaccination_program.user_id == current_user.id
      signed_public_url = sign_public_url_for_today(params[:id])
      render json: { vaccinationProgram: @vaccination_program, signedPublicURL: signed_public_url }
    else
      render status: 500, json: { errors: ['Vaccination Program not found'] }
    end
  rescue ActiveRecord::RecordNotFound
    render status: 500, json: { errors: ['Vaccination Program not found'] }
  end

  def create
    @vaccination_program = VaccinationProgram.new(vaccination_program_params)
    @vaccination_program.user_id = current_user.id
    if @vaccination_program.save
      render json: { status: :created, vaccinationProgram: @vaccination_program }
    else
      render status: 500, json: { errors: @vaccination_program.errors.full_messages }
    end
  end

  def update
    @vaccination_program = VaccinationProgram.find(params[:id])
    if @vaccination_program.user_id == current_user.id && @vaccination_program.update(vaccination_program_params)
      render json: { vaccinationProgram: @vaccination_program }
    else
      render status: 500, json: { errors: ['Vaccination Program not found'] }
    end
  end

  def verify
    # can be run logged off.
    @vaccination_program = VaccinationProgram.find(params[:id])
    verified = verify_public_url_for_today(params[:id], params[:signature], @vaccination_program.user)
    if verified
      render json: { verified: verified, vaccinationProgram: @vaccination_program }
    else
      render status: 500, json: { verified: verified, errors: ['Invalid Sinature', 'QR code might be expired', 'Try scanning your code again'] }
    end
  rescue ActiveRecord::RecordNotFound
    render status: 500, json: { errors: ['Invalid Sinature', 'QR code might be expired', 'Try scanning your code again'] }
  end

  def certify
    # can be run logged off.
    @vaccination_program = VaccinationProgram.find(params[:id])
    verified = verify_public_url_for_today(params[:id], CGI::unescape(params[:certificate][:program_signature]), @vaccination_program.user)
    if verified
      cert = signed_public_certificate(@vaccination_program, params[:certificate][:vaccinee])
      render json: { verified: verified, certificate: cert }
    else
      render status: 500, json: { verified: verified, errors: ['Cannot certify this record'] }
    end
  rescue ActiveRecord::RecordNotFound
    render status: 500, json: { errors: ['Invalid Sinature', 'QR code might be expired', 'Try scanning your code again'] }
  end

  private

  def certificate_message(vac_prog, vaccinee)
    "#{Time.now.strftime('%Y%m%d')}" \
      "/#{CGI.escape(vac_prog.brand&.upcase || '')}" \
      "/#{CGI.escape(vac_prog.product&.upcase || '')}" \
      "/#{CGI.escape(vac_prog.lot&.upcase || '')}" \
      "/#{vac_prog.required_doses}"\
      "/#{CGI.escape(vaccinee&.upcase || '')}" \
      "/#{CGI.escape(vac_prog.route&.upcase || '')}" \
      "/#{CGI.escape(vac_prog.dose&.upcase || '')}"
  end

  def rm_pad(base32text)
    base32text.gsub '=', ''
  end

  def pad(base32str)
    base32str +
      case base32str.length % 8
      when 2 then '======'
      when 4 then '===='
      when 5 then '==='
      when 7 then '='
      else ''
      end
  end

  def signed_public_certificate(vac_prog, vaccinee)
    message = certificate_message(vac_prog, vaccinee)
    signature = ''

    api_url = Rails.env.production? ? 'healthpassport-api.vitorpamplona.com' : 'localhost:3000'
    pub_key_url = "#{api_url}/U/#{vac_prog.user.id}/KEY".upcase

    if vac_prog.user.private_key.include? 'RSA'
      private_key = OpenSSL::PKey::RSA.new(vac_prog.user.private_key)
      signature = private_key.sign(OpenSSL::Digest.new('SHA256'), message)
    else
      sk = OpenSSL::PKey::EC.new(vac_prog.user.private_key)
      signature = sk.dsa_sign_asn1(Digest::SHA256.digest(message))
    end

    signatureBase32 = rm_pad(Base32.encode(signature))

    "CRED:BADGE:2:#{signatureBase32}:#{pub_key_url}:#{message}"
  end

  def generate_certificate_url(id)
    ui_url = Rails.env.production? ? 'https://healthpassport.vitorpamplona.com' : 'http://localhost:3001'
    "#{ui_url}/generateCertificate/#{id}?date=#{Time.now.strftime('%Y-%m-%d')}"
  end

  def sign_public_url_for_today(id)
    message = generate_certificate_url(id)

    if current_user.private_key.include? 'RSA'
      private_key = OpenSSL::PKey::RSA.new(current_user.private_key)
      signature = private_key.sign(OpenSSL::Digest.new('SHA256'), message)
    else
      sk = OpenSSL::PKey::EC.new(current_user.private_key)
      signature = sk.dsa_sign_asn1(message)
    end

    base64_escaped_signature = CGI.escape(Base64.encode64(signature))
    "#{message}&signature=#{base64_escaped_signature}"
  end

  def verify_public_url_for_today(id, signature, user)
    message = generate_certificate_url(id)
    verified = false
    if user.private_key.include? 'RSA'
      public_key = OpenSSL::PKey::RSA.new(user.public_key)
      verified = public_key.verify(OpenSSL::Digest.new('SHA256'), Base64.decode64(signature), message)
    else
      vk = OpenSSL::PKey::EC.new(user.public_key)
      verified = vk.dsa_verify_asn1(message, Base64.decode64(signature))
    end
    verified
  end

  def vaccination_program_params
    params.require(:vaccinationProgram).permit(:vaccinator, :brand, :product, :lot, :dose, :route, :required_doses, :next_dose_in_days)
  end
end
