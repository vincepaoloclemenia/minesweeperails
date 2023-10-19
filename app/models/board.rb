class Board < ApplicationRecord
  before_validation :plant_bombs

  validates :name, :user_email, :height, :width, :bombs, presence: true
  validates :user_email, :name, uniqueness: { case_sensitive: true }
  validates :height, :width, numericality: { greater_than: 1 }

  def draw_board
    BoardGenerator.new(height:, width:, string: bombs, return_2d_array: true).call
  end

  private

  def plant_bombs
    self.bombs = BoardGenerator.new(height:, width:).call
  rescue StandardError => e
    errors.add(:base, e.message)
  end
end
