class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|    
      t.string :csv_file_name
      t.string :csv_content_type
      t.integer :csv_file_size
      t.integer :num_imported, :default => 0
    end
  end

  def self.down
   drop_table :imports
  end
end
