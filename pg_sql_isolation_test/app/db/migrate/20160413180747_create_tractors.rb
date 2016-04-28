class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.references :user, index: true, primary_key: true

      t.timestamps null: false
    end
  end
end
