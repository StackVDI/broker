class StartMachine
  include Sidekiq::Worker
    sidekiq_options :retry => false

    def perform(machine_id)
      if (Machine.paused(Machine.find(machine_id).image).count <= Machine.find(machine_id).image.number_of_instances)
        clave = (0...16).map { ('a'..'z').to_a[rand(26)] }.join
        @machine = Machine.find_by_id(machine_id)
        @machine.cloud_create
#        sleep(rand(0.1...5.0))
        @machine.set_ip
          # TODO 
      # if machine.status == "BUILD"
      else 
        @machine = Machine.find_by_id(machine_id)
        @machine.destroy
      end
      rescue 
        @machine.destroy
        GeneralMailer.errorMail("Error Creating Machine. Quota problems? Sidekiq Launched?").deliver
    end
end
