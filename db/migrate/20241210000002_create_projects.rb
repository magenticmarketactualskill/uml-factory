class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'active', null: false

      t.timestamps
    end

    add_index :projects, [:user_id, :status]
    add_index :projects, :updated_at
  end
end
