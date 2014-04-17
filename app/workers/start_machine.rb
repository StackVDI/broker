class StartMachine
  include Sidekiq::Worker
    def perform(machine_id)
        clave = (0...16).map { ('a'..'z').to_a[rand(26)] }.join
        machine = Machine.find_by_id(machine_id)
        machine.cloud_create
#        sleep 10
#        machine.pause
    end
end
