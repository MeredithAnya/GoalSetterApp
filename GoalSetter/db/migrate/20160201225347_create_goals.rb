class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.string :view_status, null: false
      t.string :title, null: false
      t.text :description, null: false

      t.timestamps null: false
    end
    add_index :goals, :user_id
  end
end
