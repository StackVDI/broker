class StartMachine
  include Sidekiq::Worker
    def perform(machine_id)
      if (Machine.paused(Machine.find(machine_id).image).count <= Machine.find(machine_id).image.number_of_instances)
        clave = (0...16).map { ('a'..'z').to_a[rand(26)] }.join
        machine = Machine.find_by_id(machine_id)
        machine.cloud_create

      else 
        machine = Machine.find_by_id(machine_id)
        machine.destroy
      end
#        sleep 10
#        machine.pause
    end
end
