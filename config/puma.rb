daemonize
pidfile 'tmp/pids/puma.pid'
bind 'unix:///tmp/openvdi.sock'
preload_app!
