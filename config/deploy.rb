# config valid only for Capistrano 3.1
lock '3.3.5'

# Application Name
set :application, :memrybackend

# Setting the deployment user
set :user, 'deployer'

# Default value for :scm is :git
set :scm, :git

set :repository, 'git@github.com:jakeandliss/memrybackend.git'

set :branch, 'develop'

set :scm_passphrase, ''

# Default deploy_to directory
set :deploy_to, "/home/#{user}/#{application}"

# Default value for :log_level is :debug
set :log_level, :debug


# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, false

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :system
set :rbenv_ruby, File.read(File.expand_path('../../.ruby-version', __FILE__))

namespace :deploy do

  task :reload_unicorn do
    on roles(:web), in: :sequence, wait: 5 do
      execute "sudo /sbin/service unicorn reload"
    end
  end

  task :restart_background do
    on roles(:background), in: :sequence, wait: 5 do
      execute "sudo /sbin/service nest restart"
    end
  end

  desc 'Restart application'
  task :restart do
  end

  after :publishing, :restart
  after :restart, :restart_background
  after :restart, :reload_unicorn

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

desc "Echo environment vars"
namespace :env do
  task :echo do
    on roles(:all) do |host|
      execute "echo printing out cap info on remote server"
      execute "echo $PATH"
      execute "printenv"
    end
  end
end

