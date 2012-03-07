# RVM bootstrap
#$:.unshift(File.expand_path('./lib' ,ENV['rvm_path']))

#require 'rvm/capistrano'
#set :rvm_ruby_string, '1.9.2-p290'

# rbenv
set :default_environment, {
  "PATH" => "/home/`whoami`/.rbenv/shims:/home/`whoami`/.rbenv/bin:$PATH",
}

# bundler bootstrap
require 'bundler/capistrano'

# main details
set :application, "user_layer"

set :user, "app"
set :rvm_type, :user
set :deploy_to, "/home/app/applications/user_layer"
role :web, "brainpage.cn"
role :app, "brainpage.cn"
role :db,  "brainpage.cn", :primary => true

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, "5"

# repo details
set :scm, :git
set :scm_username, "jpalley"
set :repository, "git@github.com:ecoinventions/user_layer.git"
set :branch, "master"
set :git_enable_submodules, 1

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

  # desc "init whenever"
  # task :init_whenever, :role => :app do
  #   run "cd #{release_path} && RAILS_ENV=production whenever -i --update-crontab #{application}"
  # end
end

desc "custom_setup"
task :custom_setup, :role => :app do
  %w{config data}.each do |dir|
    run "cd #{deploy_to}/shared && mkdir #{dir}"
  end
end


after 'deploy:setup', :custom_setup
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:restart', 'deploy:cleanup'