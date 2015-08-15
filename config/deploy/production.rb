set :rails_env, 'production'
server '', user: 'deployer', roles: %w{web app}
server '', user: 'deployer', roles: %w{web app}