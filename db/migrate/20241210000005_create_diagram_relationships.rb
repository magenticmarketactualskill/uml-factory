class CreateDiagramRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :diagram_relationships do |t|
      t.references :diagram, null: false, foreign_key: true
      t.references :source_element, null: false, foreign_key: { to_table: :diagram_elements }
      t.references :target_element, null: false, foreign_key: { to_table: :diagram_elements }
      t.string :relationship_type, null: false
      t.json :properties, default: {}

      t.timestamps
    end

    add_index :diagram_relationships, :relationship_type
    add_index :diagram_relationships, [:source_element_id, :target_element_id], 
              name: 'index_relationships_on_source_and_target'
  end
end
