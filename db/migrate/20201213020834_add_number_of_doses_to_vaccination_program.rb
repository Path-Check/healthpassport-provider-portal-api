class AddNumberOfDosesToVaccinationProgram < ActiveRecord::Migration[6.0]
  def change
    add_column :vaccination_programs, :next_dose_in_days, :integer
    add_column :vaccination_programs, :required_doses, :integer
  end
end
