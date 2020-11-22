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
    if @vaccination_program && @vaccination_program.user_id == current_user.id
      render json: { vaccinationProgram: @vaccination_program }
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

  private

  def vaccination_program_params
    params.require(:vaccinationProgram).permit(:vaccinator, :brand, :product, :lot, :dose, :route, :signature)
  end
end
