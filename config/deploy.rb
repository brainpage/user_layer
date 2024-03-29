# RVM bootstrap
#$:.unshift(File.expand_path('./lib' ,ENV['rvm_path']))
#require 'bundler/capistrano'
#require 'rvm/capistrano'
#set :rvm_ruby_string, '1.9.2-p290'
`ssh-add`
# rbenv
set :default_environment, {
  "PATH" => "/home/`whoami`/.rbenv/shims:/home/`whoami`/.rbenv/bin:$PATH",
}

# bundler bootstrap
require 'bundler/capistrano'

# main details
set :application, "user_layer"
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :user, "app"
set :rvm_type, :user
set :deploy_to, "/home/app/applications/user_layer"
role :web, "50.112.132.214"#, "brainpage.cn"
role :app, "50.112.132.214"
role :db,  "50.112.132.214", :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, "5"

# repo details
set :scm, :git
set :scm_username, "jpalley"
set :repository, "git@github.com:brainpage/user_layer.git"
set :branch, "master"
set :git_enable_submodules, 1

#load "deploy/assets"
# tasks
namespace :bundle do
  desc "Run bundler, installing gems"
  task :install, :roles => :app do
    run "cd #{release_path} && bundle install --without=development test"
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path} && BUNDLE_GEMFILE=#{current_path}/Gemfile bundle exec unicorn_rails -E production -c #{current_path}/config/unicorn.rb -D"
  end

  task :stop, :roles => :app do
    run "kill -QUIT `cat #{current_path}/tmp/pids/unicorn.pid`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "kill -USR2 `cat #{current_path}/tmp/pids/unicorn.pid`"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    %w{database.yml unicorn.rb}.each do |config|
      run "cd #{release_path} && rm -rf config/#{config} && ln -sf ../../../shared/config/#{config} config/"
    end
    
    # %w{data}.each do |dir|
    #   run "cd #{release_path} && rm -rf #{dir} && ln -sf ../../shared/#{dir} ."
    # end
  end

  task :symlink_downloads, :roles => :app do 
    run "cd #{release_path} && ln -sf ../../../shared/downloads/ public/"
  end

  # desc "init whenever"
  # task :init_whenever, :role => :app do
  #   run "cd #{release_path} && RAILS_ENV=production whenever -i --update-crontab #{application}"
  # end
  
 #task :ln_assets do
 #  run <<-CMD
 #    rm -rf #{latest_release}/public/assets &&
 #    mkdir -p #{shared_path}/assets &&
 #    ln -s #{shared_path}/assets #{latest_release}/public/assets
 #  CMD
 #end
 #
 #task :assets do
 #  update_code
 #  ln_assets
 #
 #  run_locally "rake assets:precompile"
 #  run_locally "cd public; tar -zcvf assets.tar.gz assets"
 #  #run "cd #{shared_path}; rm assets.tar.gz; rm -rf assets;"
 #  top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
 #  run "cd #{shared_path}; tar -zxvf assets.tar.gz"
 #  run_locally "rm public/assets.tar.gz"
 #  run_locally "rm -rf public/assets"
 #
 #  create_symlink
 #  restart
 #end
  
end



desc "custom_setup"
task :custom_setup, :role => :app do
  %w{config data}.each do |dir|
    run "cd #{deploy_to}/shared && mkdir #{dir}"
  end
end

desc "deploy the precompiled assets"
task :deploy_assets, :except => { :no_release => true } do
    run_locally("rake assets:clean && rake assets:precompile")
    run_locally "cd public; tar -zcvf assets.tar.gz assets"
    upload("public/assets.tar.gz", "#{release_path}/public", :via => :scp)
    run "cd #{release_path}/public; tar -zxvf assets.tar.gz; rm assets.tar.gz"
    run_locally("rake assets:clean")
    run_locally "cd public; rm assets.tar.gz"
end


after 'deploy:setup', :custom_setup
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code', :deploy_assets
after 'deploy:update_code', 'deploy:symlink_downloads'
after 'deploy:restart', 'deploy:cleanup'

#grant all privileges on user_layer_production.* to user_layer@'10.0.0.%' IDENTIFIED BY 'ap95734h7ksdfjlz'
#Setup database correctly: 
