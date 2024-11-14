# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "lista_de_compras"
set :repo_url, "git@github.com:Naeb/lista_de_compras.git"
set :deploy_to, "/var/www/lista_compras"
set :branch, 'main'

set :linked_files, fetch(:linked_files, []).push("config/database.yml", "config/master.key")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system")

set :rbenv_type, :user
set :rbenv_ruby, '3.3.6'
set :keep_releases, 5

before 'deploy:restart', 'deploy:compile_assets_locally'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc 'Compile assets locally and then rsync to web servers'
  task :compile_assets_locally do
    run_locally do
      with rails_env: fetch(:stage) do
        execute 'bundle exec rake assets:precompile'
      end
    end
    on roles(:web) do
      within release_path do
        execute :mkdir, '-p', 'public/assets'
        upload!('./public/assets/', "#{release_path}/public/assets", recursive: true)
      end
    end
    run_locally { execute 'rm -rf public/assets' }
  end
end