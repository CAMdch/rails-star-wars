class DropPeople < ActiveRecord::Migration[6.1]
  def change
    drop_table :castings
    drop_table :people
  end
end
