class StartMachine
  include Sidekiq::Worker
    def perform(machine_id)
        machine = Machine.find_by_id(machine_id)
        machine.cloud_create
        sleep 10
        machine.pause
    end
end
