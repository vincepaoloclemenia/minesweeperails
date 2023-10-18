class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.string :bombs, null: false
      t.integer :height, null: false
      t.integer :width, null: false
      t.string :user_email, null: false, index: true
      t.string :name, null: false, index: true

      t.timestamps
    end
  end
end
