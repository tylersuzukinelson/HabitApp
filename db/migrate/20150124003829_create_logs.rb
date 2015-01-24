class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :user, index: true
      t.references :habit, index: true
      t.timestamp :logged

      t.timestamps null: false
    end
    add_foreign_key :logs, :users
    add_foreign_key :logs, :habits
  end
end
