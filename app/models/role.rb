class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_role
  validates :name, presence: true, uniqueness: true
end
