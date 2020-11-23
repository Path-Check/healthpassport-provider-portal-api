# frozen_string_literal: true

class VaccinationProgramsController < ApplicationController
  def index
    @vaccination_programs = current_user.vaccination_programs
    if @vaccination_programs
      render json: { vaccinationPrograms: @vaccination_programs }
    else
      render json: { status: 500, errors: ['no programs found'] }
    end
  end

  def show
    @vaccination_program = VaccinationProgram.find(params[:id])
    signed_public_url = signed_public_url_for_today(params[:id])
    puts signed_public_url
    if @vaccination_program && @vaccination_program.user_id == current_user.id
      render json: { vaccinationProgram: @vaccination_program, signedPublicURL: signed_public_url }
    else
      render json: { status: 500, errors: ['program not found'] }
    end
  end

  def create
    @vaccination_program = VaccinationProgram.new(vaccination_program_params)
    @vaccination_program.user_id = current_user.id
    if @vaccination_program.save
      render json: { status: :created, vaccinationProgram: @vaccination_program }
    else
      render json: { status: 500, errors: @vaccination_program.errors.full_messages }
    end
  end

  def update
    @vaccination_program = VaccinationProgram.find(params[:id])
    if @vaccination_program.user_id == current_user.id && @vaccination_program.update(vaccination_program_params)
      render json: { vaccinationProgram: @vaccination_program }
    else
      render json: { status: 500, errors: ['program not found'] }
    end
  end

  def verify
    # can be run logged off.
    verified = verify_public_url_for_today(params[:id], params[:signature])
    if verified
      @vaccination_program = VaccinationProgram.find(params[:id])
      render json: { verified: verified, vaccinationProgram: @vaccination_program }
    else
      render json: { verified: verified }
    end
  end

  private

  def generate_certificate_url(id)
    ui_url = Rails.env.production? ? 'http://healthpassport.vitorpamplona.com' : 'http://localhost:3001'
    "#{ui_url}/generateCertificate/#{id}?date=#{Time.now.strftime('%Y-%m-%d')}"
  end

  def signed_public_url_for_today(id)
    message = generate_certificate_url(id)
    private_key = OpenSSL::PKey::RSA.new(current_user.private_key)
    signature = private_key.sign(OpenSSL::Digest.new('SHA256'), message)
    base64_escaped_signature = CGI::escape(Base64.encode64(signature))
    "#{message}&signature=#{base64_escaped_signature}"
  end

  def verify_public_url_for_today(id, signature)
    message = generate_certificate_url(id)
    public_key = OpenSSL::PKey::RSA.new(current_user.public_key)
    public_key.verify(OpenSSL::Digest.new('SHA256'), Base64.decode64(signature), message)
  end

  def vaccination_program_params
    params.require(:vaccinationProgram).permit(:vaccinator, :brand, :product, :lot, :dose, :route, :signature)
  end
end
