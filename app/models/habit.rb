class Habit < ActiveRecord::Base
  belongs_to :user
  has_many :logs, dependent: :destroy
  validates :title, presence: true
  validates :interval, numericality: {greater_than: 0, only_integer: true}
  validates :forgiveness, numericality: {greater_than_or_equal_to: 0, only_integer: true}
  validate :set_defaults

  private

  def set_defaults
    self.longest_streak = 0
    self.current_streak = 0
    self.public = false
  end
end
