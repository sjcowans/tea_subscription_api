class Subscription < ApplicationRecord

  enum status: { Active: 1, Inactive: 0 }
  enum frequency: { Monthly: 1, Weekly: 2, BiMonthly: 3}
  validate :check_frequency
  validates :price, presence: true, numericality: true
  validates :title, presence: true 
  validates :status, presence: true
  validates :frequency, presence: true

  def check_frequency
    Subscription.frequencies.include?(frequency)
  end
end