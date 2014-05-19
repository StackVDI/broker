When(/^I visit roles list link$/) do
  click_link 'Groups'
end

When(/^I click in admin list users link$/) do
  click_link "see_users_from_group_#{Role.first.id}" 
end

When(/^I add a role$/) do
  click_link ('Add role')
  fill_in 'role_name', :with  => 'newrole'
  fill_in 'role_machine_lifetime', :with  => '4'
  fill_in 'role_machine_idletime', :with  => '2'
  click_button 'Create Role'
end

When(/^I edit a role$/) do
  click_link ('Add role')
  fill_in 'role_name', :with  => 'newrole'
  fill_in 'role_machine_lifetime', :with  => '5'
  fill_in 'role_machine_idletime', :with  => '7'
  click_button 'Create Role'
  click_link 'edit_role_2'
  fill_in 'role_name', :with => 'newrole2'
  fill_in 'role_machine_lifetime', :with  => '6'
  fill_in 'role_machine_idletime', :with  => '1'
  click_button 'Edit Role'
end

When(/^I delete a role$/) do
  click_link ('Add role')
  fill_in 'role_name', :with  => 'newrole'
  click_button 'Create Role'
  click_link 'delete_role_3'
end

######## THEN

Then(/^I can see the roles list$/) do
  page.should have_content "Groups"  
  page.should have_content "admin"
  page.should have_content "You can manage groups in this page"
end

When(/^I visit roles list link blindy$/) do
  visit administration_list_groups_path
end

Then(/^I can see users with admin rol$/) do
  page.should have_content "John"
  page.should have_content "Doe" 
end

Then(/^I can see the new rol in the roles list$/) do
  page.should have_content "newrole"
  page.should have_content "4"
  page.should have_content "2"
end

Then(/^I can see the editted rol in the roles list$/) do
  page.should have_content 'newrole2'
  page.should have_content "6"
  page.should have_content "1"

end

Then(/^I can't see the deleted rol in the roles list$/) do
  page.should_not have_content 'newrole'
end

