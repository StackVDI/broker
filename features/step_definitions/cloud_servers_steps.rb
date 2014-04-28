Given(/^I create a image in the group 'primero'$/) do
  role = Role.create(:name => 'primero')
  role.save
  @image = FactoryGirl.build(:image, :cloud_server => @cloudserver)
  @image.roles << role
  @image.save
end

When(/^I visit the cloud servers link$/) do
  click_link 'Cloud servers'
end

When(/^I click in the cloud servers link$/) do
  click_link 'Cloud servers'
end

When(/^I click in the images link of the first cloud server$/) do
  click_link 'cloud_server_images_1' 
end

When(/^I add a cloud server$/) do
    click_link 'Add Cloud Server'
    fill_in "cloud_server_name", :with => 'Openstack 1'
    fill_in "cloud_server_description", :with => 'My openstack server'
    fill_in "cloud_server_username", :with => 'adan'
    fill_in "cloud_server_password", :with => 'cambiame'
    fill_in "cloud_server_url", :with => 'http://nube.inf.um.es:5000/v2.0/'
    click_button 'Create Cloud server'
end

When(/^I delete the cloud server$/) do
    click_link 'delete_cloud_server_1'
end

When(/^I edit a cloud server$/) do
    click_link 'edit_cloud_server_1'
    fill_in "cloud_server_name", :with => 'Openstack 1'
    fill_in "cloud_server_description", :with => 'My openstack server edited'
    fill_in "cloud_server_username", :with => 'adan'
    fill_in "cloud_server_password", :with => 'cambiame'
    fill_in "cloud_server_url", :with => 'http://nube.inf.um.es:5000/v2.0/'
    click_button 'Update Cloud server'
end

When(/^I visit the cloud server link blindy$/) do
  visit cloud_servers_path   
end

When(/^I visit the images link$/) do
  click_link 'Images'
end

When(/^I add an Image$/) do
  VCR.use_cassette('add image') {
    click_link 'Add Image'
    fill_in 'image_name', :with => 'Ubuntu server'
    fill_in 'image_description', :with => 'Default ubuntu 64 bits server'
    select 'windows7', :from => 'image_machine'
    select 'm1.tiny', :from => 'image_flavor'
    fill_in 'image_number_of_instances', :with => "2"
    click_button 'Create Image'
  }
end

Given(/^I create a cloud server$/) do
  @cloudserver = FactoryGirl.create(:cloud_server, :username => 'adan', :password => 'cambiame', :url => 'http://nube.inf.um.es:5000/v2.0/')
end

When(/^I create an Image$/) do
  @image = FactoryGirl.create(:image, :cloud_server => @cloudserver)
end

When(/^I delete an Image$/) do
  click_link "delete_image_#{@image.id}"
end

Given(/^I have available machines to run$/) do
  Machine.any_instance.stub(:cloud_create)
  Machine.any_instance.stub(:pause)
  Machine.any_instance.stub(:reboot)
  Machine.any_instance.stub(:ip)
  @cloudserver = FactoryGirl.create(:cloud_server, :username => 'adan', :password => 'cambiame', :url => 'http://nube.inf.um.es:5000/v2.0/') 
  @image = FactoryGirl.create(:image, :cloud_server => @cloudserver, :name => 'Ubuntu', :machine => "ubuntu_server_12_04_x64", :flavor => "m1.tiny" )
  Role.create(:name => "default")
  @image.roles << Role.first
  @image.save
  @machine = FactoryGirl.create(:machine, :image => @image, :user => nil)
  @machine.cloud_create
end

When(/^I launch a machine$/) do
  @machine_count = Machine.count
  click_link 'create_machine_1'
end

When(/^I visit running machines link$/) do
  click_link 'Running Machines'
end

When(/^I reboot a machine$/) do
  click_link 'reboot_machine_1'
end

When(/^I connect to a machine$/) do
  click_link 'connect_machine_1'
end

When(/^I destroy machine$/) do
  click_link 'destroy_machine_1'
end

##### THEN 

Then(/^I can see the new cloud server in the cloud servers list$/) do
    page.should have_content 'My openstack server'
end

Then(/^I can see the edited cloud server in the cloud servers list$/) do
    page.should have_content 'My openstack server edited'
end
Then(/^I can't see the edited cloud server in the cloud servers list$/) do
    page.should_not have_content 'My openstack server'
end

Then(/^I can see the new image in the image list$/) do
  page.should have_content 'Ubuntu server'
end

Then(/^I can't see the image in the image list$/) do
  page.should_not have_content @image.name   
end

Then(/^I edit the image$/) do
  VCR.use_cassette('edit image') {
    click_link "edit_image_1"
    select 'ubuntu_server_12_04_x64', :from => 'image_machine'
    click_button 'Update Image' 
  }
end

Then(/^I can see the edited image in the image list$/) do
  page.should have_content 'ubuntu_server_12_04_x64'
end

Then(/^I can see the image$/) do
  page.should have_content @image.name
end

Then(/^A new machine is created$/) do
  Machine.count.should ==(@machine_count+1)
end

Then(/^A new page is opened and connect to the new machine$/) do
  page.should have_content ('Machine launched')
end

Then(/^I can see all the running machines$/) do
  page.all('table tr').count.should == 1
end

Then(/^The machine is rebooted$/) do
  page.should have_content 'Machine has been rebooted'
end

Then(/^I can see the availabe machines for my groups$/) do
  page.should have_content 'Ubuntu'
end

Then(/^The machine is destroyed$/) do
  page.should_not have_content 'destroy_machine_1'   
end


