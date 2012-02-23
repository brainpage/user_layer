# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
[User, Care, AppList, App, Feed].each{|t| t.delete_all}

al = AppList.create(:name => "Weather", :description => "Get notified of extreme weather conditions", :url=>"remote-weather")

user = User.create(:email => "guolei@gmail.com", :password => "111111", :password_confirmation => "111111", :authentication_token => "sSCqFfknVDzP7FnyQrwq")
care = Care.create!(:name => "Mother", :phone_number => "13800138000", :owner => user)

app = App.create!(:care => care, :app_list => al, :app_token => "fo93ro3")
feed = Feed.create(:app => app, :user => user, :event => "明天将会大幅度降温6到8度，外出请注意保暖")