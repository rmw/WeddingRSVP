class RsvpMailer < ActionMailer::Base
  
  def responded(response)
    subject    'Thanks for RSVPing for Becca and Adam Get Hitched!'
    recipients response.email
    from       'Becca and Adam'
    sent_on    Time.now
    
    body       :params => responded_message_params(response), :response => response
    #TODO: add greeting with first names (add first and last names to the model or only include first names???)
  end
  
  def responded_notify(response)
    subject    "#{response.login.login_and_primary_invitee_names} has RSVPed"
    recipients ["wedding@miller-webster.com", "bmwbzz@gmail.com", "ahardy@sft.edu"]
    from       'Becca and Adam'
    sent_on    Time.now
    
    body       :response => response
  end
  
  def email_guests(guests_emails, email_subject, email_message)
    subject    email_subject
    recipients 'wedding@BeccaAndAdamGetHitched.com'
    cc         ["bmwbzz@gmail.com", "ahardy@sft.edu"]
    bcc        guests_emails
    from       'Becca and Adam'
    sent_on    Time.now
    
    body       :message => email_message
  end

  
  private
    
    def responded_message_params(response)
      params = Hash.new
      params[:intro] = "Thank you for RSVPing!"
      responded_coming_to_s(response, params)
      params[:babysitter] = "We'll be in touch about arranging babysitting." if response.need_babysitter?
      params[:closing_line] = "Looking forward to seeing you May 1 in Chicago!" if !response.invitees_that_are_coming.empty?
      params[:closing] = "Love,"
      params[:signature] = "Becca and Adam"
      params
    end
    
    def responded_coming_to_s(response, params)
      params[:invitees_coming] = responded_invitees_coming_to_s(response)
      if(response.invitees_that_are_coming.length == response.invitees_coming_to_rehearsal(true).length && response.invitees_that_are_not_coming.empty?)
        params[:invitees_coming].insert(-2, " and the rehearsal dinner")
        params[:invitees_coming_rehearsal] = ""
      else
        params[:invitees_coming_rehearsal] = responded_invitees_rehearsal_to_s(response)
      end
    end
    
    def responded_invitees_coming_to_s(response)
      coming_list = response.invitees_that_are_coming
      not_coming_list = response.invitees_that_are_not_coming
      str = responded_invitees_to_s(response, coming_list, not_coming_list, "wedding", true, "thrilled")
      if coming_list.length != 0
        str = "#{str} If you need to book a hotel room, remember to book by April 1, 2010 and make sure to follow the instructions here: http://www.BeccaAndAdamGetHitched.com/stay.htm#reserve."
      end
      str
    end
    
    def responded_invitees_rehearsal_to_s(response)
      coming_list = response.invitees_coming_to_rehearsal(true)
      not_coming_list = response.invitees_coming_to_rehearsal(false)
      str = responded_invitees_to_s(response, coming_list, not_coming_list, "rehearsal dinner", false, "excited")
      str
    end
    
    def responded_invitees_to_s(response, coming_list, not_coming_list, event_text, show_not_coming, coming_adjective)
      str = ""
      if coming_list.empty?  
        if show_not_coming
      	  str = "We're so sorry you can't make it to the #{event_text} and hope we can celebrate with you in the future."
      	end
      else
      	if !not_coming_list.empty? && show_not_coming
      	 str = "We're sorry #{response.string_of_invitees(not_coming_list)} can't make it to the #{event_text} but we're"
      	else
      	  str = "We're"
        end
      	str += " #{coming_adjective} #{response.string_of_invitees(coming_list)} will be joining us for the #{event_text}!"
      end
      str
    end
    

end
