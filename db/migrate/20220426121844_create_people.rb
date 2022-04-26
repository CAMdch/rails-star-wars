class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.integer :mass
      t.string :name
      t.string :homeworld

      t.timestamps
    end
  end
end
