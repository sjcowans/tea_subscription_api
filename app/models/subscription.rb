class Subscription < ApplicationRecord
  enum status: { Active: 1, Inactive: 0 }

  belongs_to :customer
end