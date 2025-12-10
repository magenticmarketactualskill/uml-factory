class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :projects, dependent: :destroy
  has_many :diagrams, dependent: :destroy

  # Enums
  enum :role, { user: 'user', admin: 'admin' }, default: :user

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # Scopes
  scope :admins, -> { where(role: 'admin') }
  scope :regular_users, -> { where(role: 'user') }

  # Instance methods
  def admin?
    role == 'admin'
  end

  def regular_user?
    role == 'user'
  end
end
