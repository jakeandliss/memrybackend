worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2)
APP_PATH = ENV['APP_PATH']
working_directory APP_PATH
preload_app true
timeout 60

listen APP_PATH + "/tmp/unicorn_memrybook.sock", :backlog => 64
pid APP_PATH + "/tmp/unicorn.pid"

stderr_path APP_PATH + "/log/unicorn.error.log"
stdout_path APP_PATH + "/log/unicorn.out.log"
