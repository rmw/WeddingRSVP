class Login < ActiveRecord::Base
  has_many :invitees
  has_one :response
  
  validates_presence_of :name
  
  validate :password_not_blank
  validate :name_and_password_unique
  
  def self.authenticate(name, password)
    login = Login.find_by_name_and_password(name, password)
    if !login && name.downcase != 'guest'
      #try other invitees
      login = Login.find_by_password(password)
      logger.info(login.to_s)
      invitees = Invitee.find(:first, :conditions => ["name like '#{name} %' and login_id = ?", login.id])
      logger.info(invitees.to_s)
      if !invitees
        login = nil
      end
    end
    login
  end
  
  def self.find_by_name_and_password(name, password)
    logger.info("Login.find_by_name_password")
    login = self.find(:first, :conditions => { :name => name, :password => password })
    login
  end
  
  def has_response?
    !self.response.nil?
  end
  
  def primary_invitee
    invitees.find(:first, :conditions => { :is_primary => 1})
  end
  
  def non_primary_invitees
    invitees.find(:all, :conditions => { :is_primary => 0 }, :order => :is_kid)
  end
  
  def primary_invitee_name
    invitee = primary_invitee
    if primary_invitee
      invitee.name 
    else 
        ""
    end
  end
  
  def login_and_primary_invitee_names
    "#{primary_invitee_name}(#{name})"
  end
  
  def login_and_password
    "#{name} (#{password})"
  end
  
  def self.find_all_order_by_name
    self.find(:all, :order => :name)
  end
  
  protected
  
    def password_not_blank
      errors.add(:password, "Missing password") if password.blank?
    end
    
    def name_and_password_unique
      login = Login.find_by_name_and_password(name, password)
      if !login.nil? && id != login.id
        errors.add(:password, "and name must be unique")
      end
    end
  
end
