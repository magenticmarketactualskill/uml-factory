class Project < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :diagrams, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :status, inclusion: { in: %w[active archived] }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :archived, -> { where(status: 'archived') }
  scope :recent, -> { order(updated_at: :desc) }

  # Instance methods
  def active?
    status == 'active'
  end

  def archived?
    status == 'archived'
  end

  def archive!
    update(status: 'archived')
  end

  def activate!
    update(status: 'active')
  end

  def diagram_count
    diagrams.count
  end
end
