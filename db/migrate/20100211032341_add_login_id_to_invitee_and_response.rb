class AddLoginIdToInviteeAndResponse < ActiveRecord::Migration
  def self.up
    add_column :invitees, :login_id, :integer, :default => 0
    add_column :responses, :login_id, :integer, :default => 0
  end

  def self.down
    remove_column :invitees, :login_id
    remove_column :responses, :login_id
  end
end
