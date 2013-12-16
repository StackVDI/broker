When(/^I visit roles list link$/) do
  click_link 'Groups'
end

When(/^I click in admin list users link$/) do
  click_link "see_users_from_group_#{Role.first.id}" 
end

When(/^I add a role$/) do
  click_link ('Add role')
  fill_in 'role_name', :with  => 'newrole'
  click_button 'Create Role'
end

When(/^I edit a role$/) do
  click_link ('Add role')
  fill_in 'role_name', :with  => 'newrole'
  click_button 'Create Role'
  click_link 'edit_role_2'
  fill_in 'role_name', :with => 'newrole2'
  click_button 'Edit Role'
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
  page.should have_content "John Doe" 
end

Then(/^I can see the new rol in the roles list$/) do
  page.should have_content "newrole"
end

Then(/^I can see the editted rol in the roles list$/) do
  page.should have_content 'newrole2'
end
