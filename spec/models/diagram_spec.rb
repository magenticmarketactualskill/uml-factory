require 'rails_helper'

RSpec.describe Diagram, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
    it { should have_many(:diagram_elements).dependent(:destroy) }
    it { should have_many(:diagram_relationships).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_inclusion_of(:diagram_type).in_array(%w[use_case class sequence]) }
  end

  describe 'scopes' do
    let!(:use_case_diagram) { create(:diagram, diagram_type: 'use_case') }
    let!(:class_diagram) { create(:diagram, diagram_type: 'class') }
    let!(:sequence_diagram) { create(:diagram, diagram_type: 'sequence') }

    it 'filters use case diagrams' do
      expect(Diagram.use_case_diagrams).to include(use_case_diagram)
      expect(Diagram.use_case_diagrams).not_to include(class_diagram)
    end

    it 'filters class diagrams' do
      expect(Diagram.class_diagrams).to include(class_diagram)
      expect(Diagram.class_diagrams).not_to include(use_case_diagram)
    end

    it 'filters sequence diagrams' do
      expect(Diagram.sequence_diagrams).to include(sequence_diagram)
      expect(Diagram.sequence_diagrams).not_to include(class_diagram)
    end
  end

  describe '#export_as_plantuml' do
    context 'for use case diagram' do
      let(:diagram) { create(:diagram, diagram_type: 'use_case') }
      
      it 'generates PlantUML syntax' do
        plantuml = diagram.export_as_plantuml
        expect(plantuml).to include('@startuml')
        expect(plantuml).to include('@enduml')
      end
    end

    context 'for class diagram' do
      let(:diagram) { create(:diagram, diagram_type: 'class') }
      
      it 'generates PlantUML syntax' do
        plantuml = diagram.export_as_plantuml
        expect(plantuml).to include('@startuml')
        expect(plantuml).to include('@enduml')
      end
    end
  end

  describe '#validate_uml_model' do
    let(:diagram) { create(:diagram) }
    
    it 'returns validation result' do
      result = diagram.validate_uml_model
      expect(result).to have_key(:valid)
      expect(result).to have_key(:errors)
    end
  end
end
