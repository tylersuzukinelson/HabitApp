class AddTurnoverTimeToHabit < ActiveRecord::Migration
  def change
    add_column :habits, :turnover_time, :integer
  end
end
