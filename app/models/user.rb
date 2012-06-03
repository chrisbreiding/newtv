class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :recoverable, :trackable,
  # :lockable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :rememberable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
