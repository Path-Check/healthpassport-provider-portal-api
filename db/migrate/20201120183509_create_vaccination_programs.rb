class CreateVaccinationPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :vaccination_programs do |t|
      t.string :vaccinator
      t.string :brand
      t.string :product
      t.string :lot
      t.string :dose
      t.string :route
      t.string :signature

      t.timestamps
    end
  end
end