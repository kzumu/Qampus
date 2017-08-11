class User < ApplicationRecord

  before_create :if_thumbnail_is_nil_thumbnail_is_random, on: :create

  has_many :posts
  has_many :univs

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_comment, through: :likes, source: :comment
  belongs_to :status


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def if_thumbnail_is_nil_thumbnail_is_random
    if thumbnail == ''
      self.thumbnail = "thumbnails/#{rand(0..9)}.png"
    else
    end
  end
end
