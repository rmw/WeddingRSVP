class LoginsController < ApplicationController
  layout "admins", :except => [:login, :logout]
  # GET /logins
  # GET /logins.xml
  def index
    #TODO: can i order by primary invitee?
    @logins = Login.find_all_order_by_name

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @logins }
    end
  end

  # GET /logins/1
  # GET /logins/1.xml
  def show
    @login = Login.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @login }
    end
  end

  # GET /logins/new
  # GET /logins/new.xml
  def new
    @login = Login.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @login }
    end
  end

  # GET /logins/1/edit
  def edit
    @login = Login.find(params[:id])
  end

  # POST /logins
  # POST /logins.xml
  def create
    @login = Login.new(params[:login])

    respond_to do |format|
      if @login.save
        flash[:notice] = 'Login was successfully created.'
        format.html { redirect_to(@login) }
        format.xml  { render :xml => @login, :status => :created, :location => @login }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @login.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /logins/1
  # PUT /logins/1.xml
  def update
    @login = Login.find(params[:id])

    respond_to do |format|
      if @login.update_attributes(params[:login])
        flash[:notice] = 'Login was successfully updated.'
        format.html { redirect_to(@login) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @login.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /logins/1
  # DELETE /logins/1.xml
  def destroy
    @login = Login.find(params[:id])
    #first destory invitees and responses
    r = Response.find_by_login_id(@login.id)
    r.destroy if !r.nil?
    Invitee.find(:all, :conditions => { :login_id => @login.id }).each { |i| i.destroy }
    @login.destroy

    respond_to do |format|
      format.html { redirect_to(logins_url) }
      format.xml  { head :ok }
    end
  end
  
  def not_responded
    @logins = Login.find_by_sql('select l.* from logins l left join responses r on l.id = r.login_id where r.login_id is null order by l.name;')
  end
  
end
