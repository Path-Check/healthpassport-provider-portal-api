class AddUserToVaccinationPrograms < ActiveRecord::Migration[6.0]
  def change
    add_reference :vaccination_programs, :user
    add_foreign_key :vaccination_programs, :users
  end
end
