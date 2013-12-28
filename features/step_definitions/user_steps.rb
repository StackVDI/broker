include Warden::Test::Helpers
Warden.test_mode!

### GIVEN ###
Given /^I am not logged in$/ do
  logout(:user)
end

### WHEN ###

When(/^I log as an admin$/) do
  @user = FactoryGirl.build(:user, :approved => true)
  @user.add_role :admin
  @user.confirm!
  @user.save
  visit '/users/sign_in'
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  click_button "Sign in"
end

When(/^I log as an user$/) do
  @user = FactoryGirl.build(:user, :name => "user", :approved => true)
  @user.confirm!
  @user.save
  visit '/users/sign_in'
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  click_button "Sign in"
end

When(/^I log as an user in the group 'primero'$/) do
  @user = FactoryGirl.build(:user, :name => "user", :approved => true)
  @user.confirm!
  @user.add_role(:primero)
  @user.save
  visit '/users/sign_in'
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  click_button "Sign in"
end


When(/^I sign up with valid data$/) do
  @user = FactoryGirl.build(:user)
  visit '/users/sign_up'
  fill_in "user_first_name", :with => @user.first_name
  fill_in "user_last_name", :with => @user.last_name
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  fill_in "user_password_confirmation", :with => @user.password
  click_button "Sign up"
end

When(/^I open the email$/) do
  open_email(@user.email)
end

When(/^I follow "(.*?)" in the email$/) do |link|
    visit_in_email(link)
end

When(/^I sign up with invalid email$/) do
  @user = FactoryGirl.build(:user)
  visit '/users/sign_up'
  fill_in "user_email", :with => "notanemail"
  fill_in "user_password", :with => @user.password
  fill_in "user_password_confirmation", :with => @user.password
  click_button "Sign up"
end

When(/^Admin approves me$/) do
  @u = User.last
  @u.approved = true  
  @u.save!
end

When(/^I click in logout$/) do
  click_link 'Logout'
end

When(/^I visit user list link$/) do
  click_link 'userslist'
end

When(/^I visit user list link blindy$/) do
  visit administration_list_users_path  
end

When(/^A user has sign up but not confirmed$/) do
  @usernotconfirmed = FactoryGirl.build(:user)
  @usernotconfirmed.save
end

When(/^A user has sign up confirmed, but not approved$/) do
  @usernotapproved = FactoryGirl.build(:user)
  @usernotapproved.confirm!
  @usernotapproved.save
end

### THEN ###
Then(/^I receive an email for confirmation$/) do
  unread_emails_for(@user.email).size.should == 1
end

Then /^I should see "(.*)" in the email body$/ do |text|
  current_email.body.should =~ Regexp.new(text)
end

Then(/^I should see a successful confirmation message$/) do
  page.should have_content "Your account was successfully confirmed."
end

Then(/^I get an email error message$/) do
  page.should have_content "Email is invalid"
end

Then(/^I sign in with valid data$/) do
  visit '/users/sign_in'
  fill_in "user_email", :with => @user.email
  fill_in "user_password", :with => @user.password
  click_button "Sign in"
end

Then(/^I should see an sign in error message$/) do
  page.should have_content "Your account has not been approved by your administrator yet"
end

Then(/^I'm not logged in$/) do
  page.current_path.should_not  == root_path
end

Then(/^I'm in the sign in page$/) do
    page.current_path.should  == new_user_session_path 
end

Then(/^I'm in root page$/) do
  page.current_path.should  == root_path
end

Then(/^I can see the admin menu$/) do 
  page.should have_content "Cloud"
  page.should have_content "Users"
end

Then(/^I can't see the admin menu$/) do
  page.should_not have_content "Admin menu"
end

Then(/^I can see the user's list$/) do
  page.should have_content @user.first_name
  page.should have_content @user.last_name
  page.should have_content @user.email
end

Then(/^I get an unauthorized error$/) do
  page.should have_content "You are not allowed to perform this action"
end

Then(/^I can see the the user in "warning"$/) do
  find("tr.warning").should have_content @usernotconfirmed.first_name
end

Then(/^I can see the the user in "info"$/) do 
  find("tr.info").should have_content @usernotapproved.first_name
end

Then(/^I click in not approved link$/) do
    click_link 'Not approved'
end

Then(/^user is approved$/) do
  @usernotapproved.reload
  @usernotapproved.should be_approved
end

Then(/^I click in delete user link$/) do
  click_link "delete_#{@usernotapproved.id}" 
end

Then(/^user is deleted$/) do
  User.find_by_id(@usernotapproved.id).should be_nil
end
