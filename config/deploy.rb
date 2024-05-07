# config valid for current version and patch releases of Capistrano
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require "capistrano/rbenv"
require 'capistrano/puma'
install_plugin Capistrano::Puma

lock "~> 3.18.1"

set :application, "Practice-aws"
set :repo_url, "git@github.com:chaithanya-m/Practice-aws.git"

set :deploy_to, '/home/ubuntu/Practice-aws'

# Avoid using sudo for deployment
set :use_sudo, false

set :branch, 'main'

# Specify linked files and directories
set :linked_files, %w{config/master.key config/database.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

set :rails_env, 'production'
set :keep_releases, 2

# Puma configuration
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute :mkdir, "-p", "#{shared_path}/tmp/sockets"
      execute :mkdir, "-p", "#{shared_path}/tmp/pids"
    end
  end
  before :start, :make_dirs
end
