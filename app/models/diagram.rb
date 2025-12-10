class Diagram < ApplicationRecord
  # Associations
  belongs_to :project
  belongs_to :user
  has_many :diagram_elements, dependent: :destroy
  has_many :diagram_relationships, dependent: :destroy

  # Constants
  DIAGRAM_TYPES = %w[use_case class sequence].freeze

  # Validations
  validates :name, presence: true
  validates :diagram_type, inclusion: { in: DIAGRAM_TYPES }

  # Scopes
  scope :use_case_diagrams, -> { where(diagram_type: 'use_case') }
  scope :class_diagrams, -> { where(diagram_type: 'class') }
  scope :sequence_diagrams, -> { where(diagram_type: 'sequence') }
  scope :recent, -> { order(updated_at: :desc) }

  # Callbacks
  after_create :create_uml_package

  # UML Store integration methods
  def uml_package
    return nil unless uml_store_id
    @uml_package ||= UMLStore::Service::ModelService.new.retrieve(uml_store_id)
  rescue StandardError => e
    Rails.logger.error("Failed to retrieve UML package: #{e.message}")
    nil
  end

  def create_uml_package
    package = UMLStore::Model::Package.new(name: name)
    service = UMLStore::Service::ModelService.new
    result = service.create(package)
    update_column(:uml_store_id, result[:id])
    package
  rescue StandardError => e
    Rails.logger.error("Failed to create UML package: #{e.message}")
    nil
  end

  def validate_uml_model
    return { valid: true, errors: [] } unless uml_package

    validation_service = UMLStore::Service::ValidationService.new
    report = validation_service.validate(uml_package)

    {
      valid: report.conforms?,
      errors: report.conforms? ? [] : report.error_messages
    }
  rescue StandardError => e
    Rails.logger.error("Failed to validate UML model: #{e.message}")
    { valid: false, errors: [e.message] }
  end

  def sync_to_uml_store
    return unless uml_package

    # Sync diagram elements to UML store
    diagram_elements.each do |element|
      element.sync_to_uml_store
    end

    # Sync relationships
    diagram_relationships.each do |relationship|
      relationship.sync_to_uml_store
    end
  end

  # Export methods
  def export_as_json
    as_json(
      include: {
        diagram_elements: {},
        diagram_relationships: {
          include: [:source_element, :target_element]
        }
      }
    )
  end

  def export_as_plantuml
    # Generate PlantUML syntax
    case diagram_type
    when 'use_case'
      generate_use_case_plantuml
    when 'class'
      generate_class_plantuml
    when 'sequence'
      generate_sequence_plantuml
    end
  end

  private

  def generate_use_case_plantuml
    lines = ["@startuml", ""]
    
    diagram_elements.where(element_type: 'actor').each do |actor|
      lines << "actor \"#{actor.properties['name']}\" as #{actor.id}"
    end
    
    lines << ""
    
    diagram_elements.where(element_type: 'use_case').each do |uc|
      lines << "usecase \"#{uc.properties['name']}\" as UC#{uc.id}"
    end
    
    lines << ""
    
    diagram_relationships.each do |rel|
      source_id = rel.source_element_id
      target_id = rel.target_element_id
      case rel.relationship_type
      when 'association'
        lines << "#{source_id} --> UC#{target_id}"
      when 'include'
        lines << "UC#{source_id} ..> UC#{target_id} : <<include>>"
      when 'extend'
        lines << "UC#{source_id} ..> UC#{target_id} : <<extend>>"
      end
    end
    
    lines << ""
    lines << "@enduml"
    lines.join("\n")
  end

  def generate_class_plantuml
    lines = ["@startuml", ""]
    
    diagram_elements.where(element_type: 'class').each do |klass|
      lines << "class #{klass.properties['name']} {"
      
      klass.properties['attributes']&.each do |attr|
        lines << "  #{attr['visibility']} #{attr['name']}: #{attr['type']}"
      end
      
      lines << "  --"
      
      klass.properties['operations']&.each do |op|
        params = op['parameters']&.join(', ') || ''
        lines << "  #{op['visibility']} #{op['name']}(#{params}): #{op['returnType']}"
      end
      
      lines << "}"
      lines << ""
    end
    
    diagram_relationships.each do |rel|
      source = rel.source_element.properties['name']
      target = rel.target_element.properties['name']
      case rel.relationship_type
      when 'association'
        lines << "#{source} -- #{target}"
      when 'aggregation'
        lines << "#{source} o-- #{target}"
      when 'composition'
        lines << "#{source} *-- #{target}"
      when 'generalization'
        lines << "#{source} --|> #{target}"
      when 'realization'
        lines << "#{source} ..|> #{target}"
      end
    end
    
    lines << ""
    lines << "@enduml"
    lines.join("\n")
  end

  def generate_sequence_plantuml
    lines = ["@startuml", ""]
    
    diagram_elements.where(element_type: 'lifeline').each do |lifeline|
      lines << "participant \"#{lifeline.properties['name']}\" as #{lifeline.id}"
    end
    
    lines << ""
    
    diagram_relationships.order(:created_at).each do |rel|
      source_id = rel.source_element_id
      target_id = rel.target_element_id
      message = rel.properties['message'] || ''
      
      case rel.relationship_type
      when 'synchronous_message'
        lines << "#{source_id} -> #{target_id}: #{message}"
      when 'asynchronous_message'
        lines << "#{source_id} ->> #{target_id}: #{message}"
      when 'return_message'
        lines << "#{source_id} --> #{target_id}: #{message}"
      end
    end
    
    lines << ""
    lines << "@enduml"
    lines.join("\n")
  end
end
