class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :vegetarian, :null => false, :default => 0
      t.integer :vegan, :null => false, :default => 0
      t.integer :gluten_free, :null => false, :default => 0
      t.integer :nut_allergy, :null => false, :default => 0
      t.string :other_food_issue
      t.string :email
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
