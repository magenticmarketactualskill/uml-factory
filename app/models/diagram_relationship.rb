class DiagramRelationship < ApplicationRecord
  # Associations
  belongs_to :diagram
  belongs_to :source_element, class_name: 'DiagramElement'
  belongs_to :target_element, class_name: 'DiagramElement'

  # Constants
  RELATIONSHIP_TYPES = {
    use_case: %w[association include extend generalization],
    class: %w[association aggregation composition generalization realization dependency],
    sequence: %w[synchronous_message asynchronous_message return_message create_message destroy_message]
  }.freeze

  # Validations
  validates :relationship_type, presence: true
  validate :relationship_type_matches_diagram_type
  validate :elements_belong_to_same_diagram

  # Serialization
  serialize :properties, coder: JSON

  # Scopes
  scope :associations, -> { where(relationship_type: 'association') }
  scope :generalizations, -> { where(relationship_type: 'generalization') }
  scope :messages, -> { where(relationship_type: ['synchronous_message', 'asynchronous_message', 'return_message']) }

  # Instance methods
  def sync_to_uml_store
    return unless diagram.uml_package

    create_or_update_uml_relationship
  end

  def create_or_update_uml_relationship
    case relationship_type
    when 'association', 'aggregation', 'composition'
      create_uml_association
    when 'generalization'
      create_uml_generalization
    when 'realization'
      create_uml_realization
    when 'dependency', 'include', 'extend'
      create_uml_dependency
    end
  end

  private

  def relationship_type_matches_diagram_type
    diagram_type_sym = diagram.diagram_type.to_sym
    valid_types = RELATIONSHIP_TYPES[diagram_type_sym] || []
    
    unless valid_types.include?(relationship_type)
      errors.add(:relationship_type, "#{relationship_type} is not valid for #{diagram.diagram_type} diagrams")
    end
  end

  def elements_belong_to_same_diagram
    if source_element.diagram_id != diagram_id
      errors.add(:source_element, "must belong to the same diagram")
    end
    
    if target_element.diagram_id != diagram_id
      errors.add(:target_element, "must belong to the same diagram")
    end
  end

  def create_uml_association
    UMLStore::Model::Association.new(
      source: source_element.uml_element,
      target: target_element.uml_element,
      aggregation_kind: aggregation_kind_from_type
    )
  end

  def create_uml_generalization
    UMLStore::Model::Generalization.new(
      specific: source_element.uml_element,
      general: target_element.uml_element
    )
  end

  def create_uml_realization
    UMLStore::Model::Realization.new(
      client: source_element.uml_element,
      supplier: target_element.uml_element
    )
  end

  def create_uml_dependency
    UMLStore::Model::Dependency.new(
      client: source_element.uml_element,
      supplier: target_element.uml_element,
      stereotype: dependency_stereotype
    )
  end

  def aggregation_kind_from_type
    case relationship_type
    when 'aggregation'
      'shared'
    when 'composition'
      'composite'
    else
      'none'
    end
  end

  def dependency_stereotype
    case relationship_type
    when 'include'
      'include'
    when 'extend'
      'extend'
    else
      nil
    end
  end
end
