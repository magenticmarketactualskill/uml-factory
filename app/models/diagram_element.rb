class DiagramElement < ApplicationRecord
  # Associations
  belongs_to :diagram
  has_many :outgoing_relationships, 
           class_name: 'DiagramRelationship',
           foreign_key: 'source_element_id',
           dependent: :destroy
  has_many :incoming_relationships,
           class_name: 'DiagramRelationship',
           foreign_key: 'target_element_id',
           dependent: :destroy

  # Constants
  ELEMENT_TYPES = {
    use_case: %w[actor use_case system_boundary note],
    class: %w[class interface package attribute operation note],
    sequence: %w[lifeline activation note]
  }.freeze

  # Validations
  validates :element_type, presence: true
  validates :position, presence: true
  validate :element_type_matches_diagram_type

  # Serialization
  serialize :position, coder: JSON
  serialize :properties, coder: JSON

  # Scopes
  scope :actors, -> { where(element_type: 'actor') }
  scope :use_cases, -> { where(element_type: 'use_case') }
  scope :classes, -> { where(element_type: 'class') }
  scope :lifelines, -> { where(element_type: 'lifeline') }

  # Instance methods
  def sync_to_uml_store
    return unless diagram.uml_package

    uml_element = create_or_update_uml_element
    update_column(:uml_store_element_id, uml_element.id) if uml_element
  end

  def create_or_update_uml_element
    case element_type
    when 'class'
      create_uml_class
    when 'actor'
      create_uml_actor
    when 'use_case'
      create_uml_use_case
    when 'interface'
      create_uml_interface
    # Add other types as needed
    end
  end

  private

  def element_type_matches_diagram_type
    diagram_type_sym = diagram.diagram_type.to_sym
    valid_types = ELEMENT_TYPES[diagram_type_sym] || []
    
    unless valid_types.include?(element_type)
      errors.add(:element_type, "#{element_type} is not valid for #{diagram.diagram_type} diagrams")
    end
  end

  def create_uml_class
    UMLStore::Model::Class.new(
      name: properties['name'] || 'UnnamedClass',
      package: diagram.uml_package,
      visibility: properties['visibility'] || 'public',
      is_abstract: properties['isAbstract'] || false
    ).tap do |klass|
      # Add attributes
      properties['attributes']&.each do |attr|
        klass.add_property(
          UMLStore::Model::Property.new(
            name: attr['name'],
            type: attr['type'],
            visibility: attr['visibility']
          )
        )
      end
      
      # Add operations
      properties['operations']&.each do |op|
        klass.add_operation(
          UMLStore::Model::Operation.new(
            name: op['name'],
            visibility: op['visibility'],
            return_type: op['returnType']
          )
        )
      end
    end
  end

  def create_uml_actor
    UMLStore::Model::Actor.new(
      name: properties['name'] || 'UnnamedActor'
    )
  end

  def create_uml_use_case
    UMLStore::Model::UseCase.new(
      name: properties['name'] || 'UnnamedUseCase'
    )
  end

  def create_uml_interface
    UMLStore::Model::Interface.new(
      name: properties['name'] || 'UnnamedInterface',
      package: diagram.uml_package
    )
  end
end
