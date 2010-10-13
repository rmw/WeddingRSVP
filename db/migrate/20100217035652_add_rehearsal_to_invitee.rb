class AddRehearsalToInvitee < ActiveRecord::Migration
  def self.up
    add_column :logins, :rehearsal_invited, :boolean, :default => false, :null => false
    add_column :invitees, :rehearsal_coming, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :logins, :rehearsal_coming
    remove_column :invitees, :rehearsal_invited
  end
end
