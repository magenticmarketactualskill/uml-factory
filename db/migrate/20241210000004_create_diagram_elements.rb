class CreateDiagramElements < ActiveRecord::Migration[8.0]
  def change
    create_table :diagram_elements do |t|
      t.references :diagram, null: false, foreign_key: true
      t.string :element_type, null: false
      t.string :uml_store_element_id
      t.json :position, null: false, default: { x: 0, y: 0 }
      t.json :properties, default: {}

      t.timestamps
    end

    add_index :diagram_elements, :element_type
    add_index :diagram_elements, :uml_store_element_id
  end
end
