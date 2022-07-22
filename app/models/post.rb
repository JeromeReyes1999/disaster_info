class Post < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :content
  has_many :comments
  belongs_to :user
  belongs_to :disaster

  mount_uploader :image, ImageUploader


  before_create :generate_unique_number
  after_commit :generate_serial_number

  def generate_unique_number
    loop do
      @short = rand(0..9999).to_s.rjust(4, '0')
      break unless Post.exists?(short_url: @short)
    end
    self.short_url = @short
  end

  def generate_serial_number
    # count_post_today = Post.where(created_at: DateTime.current.beginning_of_day..DateTime.current.end_of_day).count
    # self.update(serial_number: "#{Date.current.strftime('%y%m%d')}#{count_post_today.to_s.rjust(4, '0')}")
    ActiveRecord::Base.connection.execute("UPDATE `posts` SET `posts`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(posts.created_at, '+00:00', '+8:00'), '%y%m%d'),
                                                      (SELECT LPAD(count(*), 6, 0)
                                                       FROM `posts` where `posts`.`id` <= #{id} and DATE(CONVERT_TZ(posts.created_at, '+00:00', '+8:00')) = (select DATE(CONVERT_TZ(posts.created_at, '+00:00', '+8:00'))
                                                       FROM posts WHERE posts.id = #{id})))
                                                       WHERE posts.id = #{id}")
  end

  def to_param  # overridden
    self.serial_number
  end
  
end
