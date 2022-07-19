class Post < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :content
  has_many :comments
  belongs_to :user
  belongs_to :disaster

  mount_uploader :image, ImageUploader


  before_create :generate_unique_number

  def generate_unique_number
    loop do
      @short = rand(0..9999).to_s.rjust(4, '0')
      break unless Post.exists?(short_url: @short)
    end
    self.short_url = @short
  end
end
