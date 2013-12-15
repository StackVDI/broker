When(/^I visit roles list link$/) do
  click_link 'Groups'
end

When(/^I click in admin list users link$/) do
  click_link "see_users_from_group_#{Role.first.id}" 
end

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

