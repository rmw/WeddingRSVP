# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "admins", :except => [:login, :logout]
  before_filter :authorize, :except => :login
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
    
    def authorize
      unless Admin.find_by_id(session[:admin_id])
        flash[:notice] = "Please login"
        redirect_to :controller => 'admins', :action => 'login'
      end
    end
    
    def find_admin
      @admin = Admin.find_by_id(session[:admin_id])
    end
  
end
