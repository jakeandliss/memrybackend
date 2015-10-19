worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
APP_PATH = '/home/deployer/staging/memrybackend/current'
working_directory APP_PATH
preload_app true
timeout 60

listen "104.236.57.97:8085"
pid APP_PATH + "/tmp/unicorn.pid"

stderr_path APP_PATH + "/log/unicorn.error.log"
stdout_path APP_PATH + "/log/unicorn.out.log"
