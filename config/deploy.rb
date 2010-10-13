set :application, "rsvp"
set :ops_user, "cbsops"
set :web_user, "codebee"
set :web_domain, "#{web_user}@#{application}.beccaandadamgethitched.com"
set :ops_domain, "#{ops_user}@ops.codebeesolutions.com"

set :repository,  "#{ops_domain}:codebee/ops/git/#{application}.git"
set :deploy_to, "~/wedding/rsvp"

role :web, web_domain                          # Your HTTP server, Apache/etc
role :app, web_domain                          # This may be the same as your `Web` server
role :db,  web_domain, :primary => true             # This is where Rails migrations will run

set :deploy_via, :remote_cache

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"
set :scm_verbose, true
set :use_sudo, false
set :scm_user, ops_user
set :git_enable_submodules, 1 # if you have vendored rails

set :chmod755, "app config db lib public vendor script script/* public/disp*"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
 
 