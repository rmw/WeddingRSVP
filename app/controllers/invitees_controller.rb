class InviteesController < ApplicationController
  layout "admins", :except => [:login, :logout]
 
  # GET /invitees
  # GET /invitees.xml
  def index
    logins = Login.find_all_order_by_name
    @invitees = logins.collect { |l| l.invitees.find(:all, :order => :name ) }.flatten

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitees }
    end
  end

  # GET /invitees/1
  # GET /invitees/1.xml
  def show
    @invitee = Invitee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invitee }
    end
  end

  # GET /invitees/new
  # GET /invitees/new.xml
  def new
    @invitee = Invitee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invitee }
    end
  end

  # GET /invitees/1/edit
  def edit
    @invitee = Invitee.find(params[:id])
  end

  # POST /invitees
  # POST /invitees.xml
  def create
    @invitee = Invitee.new(params[:invitee])

    respond_to do |format|
      if @invitee.save
        flash[:notice] = 'Invitee was successfully created.'
        format.html { redirect_to(invitees_url) }
        format.xml  { render :xml => @invitee, :status => :created, :location => @invitee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invitees/1
  # PUT /invitees/1.xml
  def update
    @invitee = Invitee.find(params[:id])

    respond_to do |format|
      if @invitee.update_attributes(params[:invitee])
        flash[:notice] = 'Invitee was successfully updated.'
        format.html { redirect_to(invitees_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invitee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitees/1
  # DELETE /invitees/1.xml
  def destroy
    @invitee = Invitee.find(params[:id])
    @invitee.destroy

    respond_to do |format|
      format.html { redirect_to(invitees_url) }
      format.xml  { head :ok }
    end
  end
end
