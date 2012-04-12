# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
[User, Care, AppList, App, Feed, Sensor, SensorSubscribers].each{|t| t.delete_all}

#al = AppList.create(:name => "Weather", :description => "Get notified of extreme weather conditions", :url=>"remote-weather")

user = User.create(:email => "guolei@gmail.com", :password => "111111", :password_confirmation => "111111", :authentication_token => "sSCqFfknVDzP7FnyQrwq")
#care = Care.create!(:name => "Mother", :phone_number => "13800138000", :owner => user)
jp = User.create(:email => "jpalley@gmail.com", :password=>"jonathan", :password_confirmation => "jonathan")
#app = App.create!(:user => user, :app_list => al)

#rsi = AppList.create(:name => "Stop RSI", :description => "Analyze and stop RSI", :url=>"rsi")

#random = Sensor.create(:stype=>"random", :uuid =>"10-120-5-0-e97fcc2346bde64e0482e252acc826b7")


