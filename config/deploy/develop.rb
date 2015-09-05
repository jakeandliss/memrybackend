set :deploy_to, "/home/#{fetch(:user)}/staging/#{fetch(:application)}"
set :password, ask('Server password:', nil, echo: false)

set :rvm_ruby_version, '2.2.3'      # Defaults to: 'default'

server "memrybook.com",
  user: "#{fetch(:user)}",
  port: 22,
  roles: %w{web app db},
  ssh_options: {
  user: "#{fetch(:user)}", # overrides user setting above
  forward_agent: false,
  auth_methods: %w(password),
  password: fetch(:password)
}

set :branch, "develop"

set :rails_env, "development"
