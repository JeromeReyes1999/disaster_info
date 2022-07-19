class Disaster < ApplicationRecord
  validates_presence_of :category
  has_many :post
end
