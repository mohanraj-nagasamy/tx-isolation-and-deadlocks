class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      # t.references :user, index: true
      # t.references :user, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
