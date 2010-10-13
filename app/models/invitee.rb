class Invitee < ActiveRecord::Base
  
  belongs_to :login
  has_one :response, :through => :login
  
  validates_presence_of :name
  validates_length_of :name, :minimum => 2, :too_short => "must have at least {{count}} character"
  #validates_associated :login
  
 #TODO: do i need these?
  validates_presence_of :login_id
  validates_numericality_of :login_id
  validate :login_not_null
  validate :login_exists
  
  def reset_default_response
    self.coming = 0
    self.need_babysitter = 0
    self.rehearsal_coming = 0
    logger.info(self.to_s)
  end
  
  protected
  
    def login_not_null
       errors.add(:login_id, 'must be linked to invitee') if login.nil?  
     end
     
     def login_exists
       if Login.find(login_id).nil?
         errors.add(:login_id, "doesn't exist")
        end
     end
  
end
