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
  @cloudserver = FactoryGirl.build(:cloud_server, :username => 'adan', :password => 'cambiame', :url => 'http://nube.inf.um.es:5000/v2.0/')
  @cloudserver.save
end

When(/^I create an Image$/) do
  @image = FactoryGirl.build(:image, :cloud_server => @cloudserver)
  @image.save
end

When(/^I delete an Image$/) do
  click_link "delete_image_#{@image.id}"
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
  click_link "edit_image_1"
  select 'ubuntu_server_12_04_x64', :from => 'image_machine'
  click_button 'Update Image' 
end

Then(/^I can see the edited image in the image list$/) do
  page.should have_content 'ubuntu_server_12_04_x64'
end
