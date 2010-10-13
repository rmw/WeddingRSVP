class AddPrimaryToInvitee < ActiveRecord::Migration
  def self.up
    add_column :invitees, :is_primary, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :invitees, :is_primary
  end
end
