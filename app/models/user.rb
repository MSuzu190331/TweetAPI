class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  # ユーザーが作られた後すぐ
  after_create :update_access_token!

  validates :email, presence: true

  def update_access_token!
    # トークンの生成にユーザーのidとdeviseが生成するトークン自身を使用
    self.access_token = "#{self.id}:#{Devise.friendly_token}"
    save
  end
  
end
