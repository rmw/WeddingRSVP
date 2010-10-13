class ImportsController < ApplicationController
  layout "admins", :except => [:login, :logout]
  def new
     @import = Import.new

     respond_to do |format|
       format.html # new.html.erb
       format.xml  { render :xml => @admin }
     end
   end
  
  def create
    logger.info("in create")
     @import = Import.create(params[:import])
     #@import.save
     @import.num_imported = parse_csv_file(@import.csv.path)
     if @import.num_imported > 0
       @import.save
       flash[:notice] = "#{@import.num_imported} invitees imported"
     else
       flash[:error] = "error importing invitees"
     end
     redirect_to :controller => 'invitees', :action => 'index'
  end
  
  private
  
   def parse_csv_file(path_to_csv)
     #if not installed run, sudo gem install fastercsv
     #http://fastercsv.rubyforge.org/
     require 'fastercsv'
     
     logger.info("parsing csv file ...")
    
     i = 0
     #fcsv = FasterCSV.new(FasterCSV.read(path_to_csv).to_s)
     FasterCSV.foreach(path_to_csv) do |row|
     #fcsv.each do |row|
       logger.info("#{i}: #{row.to_s}")
      # if !row.header_row?
       if i > 0
        import_invitee(row)
       end 
      i += 1
     end
     i
   end
  
   def import_invitee(row)
     #do in transaction??
     
     #login
     login_name = row[0]
     login_password = row[1] 
     login = Login.find_by_name_and_password(login_name, login_password)
     logger.info('after find login')
     if login.nil?
       logger.info('creating new login')
       login = Login.new
       login.name = login_name
       login.password = login_password
       login.rehearsal_invited = row[2]
       login.save
     end

     #update existing records?

     #invitee
     logger.info("before new invitee")
     invitee = Invitee.new
     logger.info("new Invitee")
     invitee.name = row[3]
     invitee.login_id = login.id
     invitee.is_primary = row[4]
     invitee.is_kid = row[5]
     invitee.save
     
     logger.info(invitee.errors.to_xml)
       
   end
end