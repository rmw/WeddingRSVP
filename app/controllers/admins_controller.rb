class AdminsController < ApplicationController
  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end

  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/new
  # GET /admins/new.xml
  def new
    @admin = Admin.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin }
    end
  end

  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        flash[:notice] = "Admin #{@admin.name} was successfully created."
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        flash[:notice] = "Admin #{@admin.name} was successfully updated."
        format.html { redirect_to(@admin) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url) }
      format.xml  { head :ok }
    end
  end
  
  def login
    if request.post?
      if Admin.all.empty?
        admin = Admin.new
        admin.name = params[:name]
        admin.password = params[:password]
        admin.save
      else
        admin = Admin.authenticate(params[:name], params[:password])
      end
      if admin
        session[:admin_id] = admin.id
        redirect_to(:action => "main")
      else
        session[:admin_id] = nil
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end
  
  def logout
    session[:admin_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
  
  def main
    @total_responses = Response.count
    @total_guests = Invitee.count(:conditions => "coming = 1")
    @rsvp_time = DateTime.strptime("04/01/2010", "%m/%d/%Y").to_time
    @wedding_time = DateTime.strptime("05/01/2010", "%m/%d/%Y").to_time
    @total_logins = Login.count
  end
  
  def coming
    event = params[:event].downcase
    coming = (params[:coming].downcase == "true" ? true : false)
    field = ""
    additional_where = ""
    if event == "wedding"
      field = "coming"
    elsif event == "rehearsal"
      field = "rehearsal_coming"
      additional_where = " and l.rehearsal_invited = true"
    else
      redirect_to(:action => "login")
    end
      @guests = Invitee.find_by_sql("select i.* from invitees i join logins l on i.login_id = l.id join responses r on l.id = r.login_id where #{field} = #{coming}#{additional_where} order by l.name, i.is_primary DESC, i.is_kid, i.name")
      @headline = "Guests who are " + (coming ? "coming" : "not coming") + " to the #{event}: #{@guests.count}"     
  end
  
  def email
    if request.post?
        event = params[:guests]
        subject = params[:subject]
        message = params[:message]
        
        list = Invitee.find(:all, :conditions => {event => true, :is_primary => true}, :order => 'name DESC')
        guests = list.collect {|i| i.response.email }
  
        RsvpMailer.deliver_email_guests(guests, subject, message)
        
        flash.now[:notice] = "Send email for #{guests} coming to #{event}!"
    end
  end
  
  protected
  
  def get_emails(event)
    
  end
  
end
