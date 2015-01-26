class Habit < ActiveRecord::Base
  belongs_to :user
  has_many :logs, dependent: :destroy
  validates :title, presence: true
  validates :interval, presence: true, numericality: {greater_than: 0, only_integer: true}
  validates :forgiveness, presence: true, numericality: {greater_than_or_equal_to: 0, only_integer: true}
  validates :turnover_time, presence: true, numericality: {greater_than_or_equal_to: 0, only_integer: true}
  validate :set_defaults
  validate :valid_turnover
  validate :set_longest_streak

  MIN_FOR_WHITE = 0
  MIN_FOR_YELLOW = 100
  MIN_FOR_ORANGE = 200
  MIN_FOR_GREEN = 300
  MIN_FOR_BLUE = 500
  MIN_FOR_VIOLET = 800
  MIN_FOR_BROWN = 1300
  MIN_FOR_BLACK = 2100
  CENTER_CIRCLE_COLOR = 'red'
  TARGET_CIRCLE_SIZE = 120
  CENTER_CIRCLE_SIZE = 20
  HABIT_CIRCLE_SIZE = TARGET_CIRCLE_SIZE - CENTER_CIRCLE_SIZE

  def generate_button
    # link
    # glow if record beaten
    if current_streak <= MIN_FOR_YELLOW
      current_color = 'white'
      next_color = 'yellow'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_WHITE) / (MIN_FOR_YELLOW - MIN_FOR_WHITE)
    elsif current_streak <= MIN_FOR_ORANGE
      current_color = 'yellow'
      next_color = 'orange'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_YELLOW) / (MIN_FOR_ORANGE - MIN_FOR_YELLOW)
    elsif current_streak <= MIN_FOR_GREEN
      current_color = 'orange'
      next_color = 'green'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_ORANGE) / (MIN_FOR_GREEN - MIN_FOR_ORANGE)
    elsif current_streak <= MIN_FOR_BLUE
      current_color = 'green'
      next_color = 'blue'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_GREEN) / (MIN_FOR_BLUE - MIN_FOR_GREEN)
    elsif current_streak <= MIN_FOR_VIOLET
      current_color = 'blue'
      next_color = 'violet'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_BLUE) / (MIN_FOR_VIOLET - MIN_FOR_BLUE)
    elsif current_streak <= MIN_FOR_BROWN
      current_color = 'violet'
      next_color = 'brown'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_VIOLET) / (MIN_FOR_BROWN - MIN_FOR_VIOLET)
    elsif current_streak <= MIN_FOR_BLACK
      current_color = 'brown'
      next_color = 'black'
      size = HABIT_CIRCLE_SIZE * (current_streak - MIN_FOR_BROWN) / (MIN_FOR_BLACK - MIN_FOR_BROWN)
    else
      current_color = 'black'
      next_color = 'black'
      size = HABIT_CIRCLE_SIZE
    end

    button_code = "<div style=\"display: inline-block; width: #{TARGET_CIRCLE_SIZE}px; height: #{TARGET_CIRCLE_SIZE}px; background: #{current_color}; border-radius: 60px;"
    if current_streak >= longest_streak
      button_code += " -webkit-box-shadow:0 0 20px #{CENTER_CIRCLE_COLOR}; -moz-box-shadow: 0 0 20px #{CENTER_CIRCLE_COLOR}; box-shadow:0 0 20px #{CENTER_CIRCLE_COLOR};"
    end
    button_code += "\">\n"
    button_code += "\t<div style=\"position:relative; width: #{size}px; height: #{size}px; background: #{next_color}; border-radius: #{(size / 2)}px; top: #{((TARGET_CIRCLE_SIZE / 2) - (size / 2))}px; left: #{((TARGET_CIRCLE_SIZE / 2) - (size / 2))}px;\">\n"
    button_code += "\t\t<div style=\"position:relative; width: #{CENTER_CIRCLE_SIZE}px; height: #{CENTER_CIRCLE_SIZE}px; background: #{CENTER_CIRCLE_COLOR}; border-radius: #{(CENTER_CIRCLE_SIZE / 2)}px; top: #{((size / 2) - (CENTER_CIRCLE_SIZE / 2))}px; left: #{((size / 2) - (CENTER_CIRCLE_SIZE / 2))}px;\">\n"
    button_code += "\t\t</div>\n\t</div>\n</div>"
    return button_code.html_safe
  end

  private

  def set_defaults
    self.longest_streak ||= 0
    self.current_streak ||= 0
    self.public ||= false
  end

  def set_longest_streak
    if current_streak >= longest_streak
      self.longest_streak = current_streak
    end
  end

  def valid_turnover
    if turnover_time >= interval
      self.turnover_time = 0
    end
  end
end
