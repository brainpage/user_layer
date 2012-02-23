# coding: utf-8
desc 'seed data'
task :seed_data => :environment do
  [User, Care, AppList, App, Feed].each{|t| t.delete_all}
  user = User.create(:email => "guolei@gmail.com", :password => "111111", :password_confirmation => "111111", :authentication_token => "sSCqFfknVDzP7FnyQrwq")
  care = Care.create(:name => "Mother", :phone_number => "13800138000")
  al = AppList.create(:name => "weather")
  app = App.create(:care => care, :app_list => al, :app_token => "fo93ro3")
  feed = Feed.create(:app => app, :user => user, :event => "明天将会大幅度降温6到8度，外出请注意保暖")
end
