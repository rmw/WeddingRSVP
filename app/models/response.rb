class Response < ActiveRecord::Base
  belongs_to :login
  has_many :invitees, :through => :login
  
  validates_numericality_of :vegetarian, :vegan, :gluten_free, :nut_allergy
  validate :numbers_must_be_positive
  validates_presence_of :login_id,:email
  validates_numericality_of :login_id
  #validates_associated :login 
  validates_associated :invitees
  validate :login_not_null
  validate :login_exists
  #TODO: validate invitees ...
  #validate that the number is not greater than the number of guests in the party
  #validate that email is an email
  validates_format_of :email,
  :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
  
  def adults
    #login = Login.find_by_id(login_id)
    #adults = login.invitees.find(:all, :conditions => { :is_kid => false }, :order => "is_primary DESC")
    unless @adults
      @adults = find_invitees_by_is_kid(false)
    end
    @adults
  end
  
  def kids
    #login = Login.find_by_id(login_id)
    #kids = Invitee.find(:all, :conditions => {:is_kid => true})
    unless @kids
      @kids = find_invitees_by_is_kid(true)
    end
    @kids
  end
  
  def adult_attributes=(adult_attributes)
    set_new_invitee_attributes(adult_attributes)
  end
  
  def kid_attributes=(kid_attributes)
   set_new_invitee_attributes(kid_attributes)
  end
  
  def invitees_that_are_coming
    unless @coming
      @coming = find_invitees_by_coming(:coming, true)
    end
    @coming
  end
  
  def invitees_that_are_not_coming
    unless @not_coming
      @not_coming = find_invitees_by_coming(:coming, false)
    end
    @not_coming
  end
  
  def invitees_coming_to_rehearsal(coming)
    list = invitees.find(:all, :conditions => { :is_kid => false, :need_babysitter => true }) #this should return nothing! this is probably bad but it works ...
    if login.rehearsal_invited
      list = find_invitees_by_coming(:rehearsal_coming, coming)
    end
    list
  end
  
  def need_babysitter?
    if invitees.find(:all, :conditions => { :need_babysitter => true} ).length > 0
      need = true
    else
      need = false
    end
    need
  end
  
  def string_of_invitees(field, coming)
    list = find_invitees_by_coming(field, coming)
    string_of_invitees(list)
  end
  
  def string_of_invitees(list)
    logger.info(list)
    if list.empty?
      ""
    else
      str = list[0].name
      len = list.length
      (1..(len-2)).each { |i| str = "#{str}, #{list[i].name}" }
      if len > 1
        i = list[len-1]
        str = "#{str} and #{i.name}"
      end
      str
    end
  end
  
  protected
    def numbers_must_be_positive
      errors.add(:vegetarian, 'should be a positive number') if vegetarian < 0
      errors.add(:vegan, 'should be a positive number') if vegan < 0
      errors.add(:gluten_free, 'should be a positive number') if gluten_free < 0
      errors.add(:nut_allergy, 'should be a positive number') if nut_allergy < 0
    end
    
    def login_not_null
       errors.add(:login_id, 'must have a login') if login.nil?
     end
     
     def login_exists
        if Login.find(login_id).nil?
          errors.add(:login_id, "doesn't exist")
         end
      end
    
    def find_invitees_by_is_kid(isKid)
      #login = Login.find_by_id(login_id)
      #guests = login.invitees.find(:all, :conditions => { :is_kid => isKid }, :order => "is_primary DESC")
      guests = invitees.find(:all, :conditions => { :is_kid => isKid }, :order => "is_primary DESC")
      guests
    end
    
    def find_invitees_by_coming(field, isComing)
      guests = invitees.find(:all, :conditions => {field => isComing}, :order => 'is_primary DESC, is_kid ASC, name DESC')
      guests
    end
    
    def set_new_invitee_attributes(invitee_attributes)
      invitee_attributes.each do |attributes|
        invitee_id = attributes[1]["id"]
        invitee = Invitee.find(invitee_id)
        invitee.update_attributes(attributes[1])
      end
    end
  
end
