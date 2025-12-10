class CreateDiagrams < ActiveRecord::Migration[8.0]
  def change
    create_table :diagrams do |t|
      t.string :name, null: false
      t.string :diagram_type, null: false
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :uml_store_id
      t.json :metadata, default: {}

      t.timestamps
    end

    add_index :diagrams, :diagram_type
    add_index :diagrams, :uml_store_id
    add_index :diagrams, :updated_at
  end
end
