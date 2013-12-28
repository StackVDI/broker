# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create(:first_name => 'Admin User', :email => 'admin@openvdi.com', :password => 'changeme')
admin.confirm!
admin.approve!
admin.add_role :admin
admin.save

user = User.create(:last_name => 'Regular User', :email => 'user@openvdi.com', :password => 'changeme')
user.confirm!
user.approve!
user.save


