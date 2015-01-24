class CreateHabits < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.references :user, index: true
      t.string :title
      t.text :description
      t.boolean :public
      t.integer :interval
      t.integer :forgiveness
      t.integer :current_streak
      t.integer :longest_streak

      t.timestamps null: false
    end
    add_foreign_key :habits, :users
  end
end
