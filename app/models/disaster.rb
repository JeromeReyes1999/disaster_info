class Disaster < ApplicationRecord
  validates_presence_of :type
  has_many :post
end
