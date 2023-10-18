class Board < ApplicationRecord
  validate :name, :user_email, :height, :width, :bombs, presence: true
  validate :use_email, uniqueness: { case_sensitive: true }
  validate :height, :width numericality: { greater_than: 1 }
end
