class AddNeedbabysitterToInvitee < ActiveRecord::Migration
  def self.up
    add_column :invitees, :need_babysitter, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :invitees, :need_babysitter
  end
end
