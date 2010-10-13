class CreateInvitees < ActiveRecord::Migration
  def self.up
    create_table :invitees do |t|
      t.string :name, :null => false
      t.boolean :coming, :null => false, :default => false
      t.boolean :is_kid, :null => false, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :invitees
  end
end
