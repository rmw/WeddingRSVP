class ResponsesController < ApplicationController
  #layout "responses", :only => [:login, :logout, :new, :create, :thanks]
  layout "admins", :except => [:login, :logout, :new, :create, :thanks]
  before_filter :find_login, :only => [:new, :create, :thanks]
  before_filter :authorizeInvitee, :only => [:new, :create, :thanks]
  skip_before_filter :authorize
  before_filter :authorizeAdmin, :except => [:new, :create, :login, :logout, :thanks]
  
  
  # GET /responses
  # GET /responses.xml
  def index
    @responses = Response.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @responses }
    end
  end

  # GET /responses/1
  # GET /responses/1.xml
  def show
    @response = Response.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @response }
    end
  end

  # GET /responses/new
  # GET /responses/new.xml
  def new
    #TODO: restrict menu for regular login user
    if !@login.has_response?
      @response = Response.new
      @response.login_id = @login.id
      @response.login = Login.find(@login.id)
     
     flash[:notice] = ""
  
      respond_to do |format|
        format.html { render(:layout => 'layouts/responses') }# new.html.erb
        format.xml  { render :xml => @response }
      end
    else
      redirect_to responses_thanks_url(:id => @login.response.id)
    end
  end

  # GET /responses/1/edit
  def edit
    @response = Response.find(params[:id])
  end

  # POST /responses
  # POST /responses.xml
  def create
    
    @response = Response.new(params[:response])
    @response.login_id = @login.id  # need to manually set this here

      if @response.save
        # send email
        begin
          RsvpMailer.deliver_responded(@response) 
        rescue
          #don't do anything if emailing them fails ...
          logger.error("couldn't email guest #{@response.login.name} with email #{@response.email}")
        end
        
        begin 
          RsvpMailer.deliver_responded_notify(@response)
        rescue
          #don't give them an error if can't send to us b/c it's still saved
          logger.error("couldn't email wedding@beccaandadamgethitched.com!")
        end
       
       flash[:notice] = 'Response was successfully created.'
        redirect_to  responses_thanks_url(:id => @login.response.id)
      else
        render :action => "new", :layout => 'layouts/responses'
      end
  end
  

  # PUT /responses/1
  # PUT /responses/1.xml
  def update
    @response = Response.find(params[:id])

    respond_to do |format|
      if @response.update_attributes(params[:response])
        flash[:notice] = 'Response was successfully updated.'
        format.html { redirect_to(@response) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @response.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /responses/1
  # DELETE /responses/1.xml
  def destroy
    @response = Response.find(params[:id])
    #TODO: put this elsewhere?? before_destory wasn't working
    for invitee in @response.invitees
      invitee.reset_default_response
      invitee.save
    end
    @response.destroy

    respond_to do |format|
      format.html { redirect_to(responses_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def login
    if request.post?
      login = Login.authenticate(params[:name], params[:password])
      if login
        session[:login_id] = login.id
        redirect_to(:action => "new")
      else
        session[:login_id] = nil
        flash[:notice] = "Invalid name/zip combination"
        render(:layout => 'layouts/responses')
      end
    else
      render(:layout => 'layouts/responses')
    end
    
  end
  
  def logout
    session[:login_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
  
  def thanks
    render(:layout => 'layouts/responses')
    @response = Response.find(params[:id])
  end
  
  protected 
  
  #TODO: need to show new if they are admin or ... admin can't create??
  def authorizeInvitee
    unless @login
      flash[:notice] = "Please login"
      redirect_to :action => "login"
    end
  end
  
  def authorizeAdmin
    authorize
  end
  
  def find_login
    @login = Login.find_by_id(session[:login_id])
  end
  
end
