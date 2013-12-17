When(/^I visit the cloud servers link$/) do
  click_link 'Cloud servers'
end

When(/^I add a cloud server$/) do
    click_link 'Add Cloud Server'
    fill_in "cloud_server_name", :with => 'Openstack 1'
    fill_in "cloud_server_description", :with => 'My openstack server'
    fill_in "cloud_server_username", :with => 'username'
    fill_in "cloud_server_password", :with => 'changeme'
    fill_in "cloud_server_url", :with => 'http://url.com/auth'
    click_button 'Create Cloud server'
end

When(/^I delete the cloud server$/) do
    click_link 'delete_cloud_server_1'
end

When(/^I edit a cloud server$/) do
    click_link 'edit_cloud_server_1'
    fill_in "cloud_server_name", :with => 'Openstack 1'
    fill_in "cloud_server_description", :with => 'My openstack server edited'
    fill_in "cloud_server_username", :with => 'username'
    fill_in "cloud_server_password", :with => 'changeme'
    fill_in "cloud_server_url", :with => 'http://url.com/auth'
    click_button 'Update Cloud server'
end

When(/^I visit the cloud server link blindy$/) do
  visit cloud_servers_path   
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

