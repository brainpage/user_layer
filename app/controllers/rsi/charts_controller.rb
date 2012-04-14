class Rsi::ChartsController < ApplicationController
  def index
    
  end
  
  def data
    if params[:type] == "bar"
      render :json => [{:name => "firefox", :value => 100}, {:name => "vmware", :value => 200}, {:name => "qq", :value => 150}].to_json
    elsif params[:q].present?
      if params[:q].include?("app-time")
        apps = ["firefox", "qq", "textmate", "eclipse", "skype", "word"]
        result = []
        0.upto(3){|i|
           w = [
             [{:v => "firefox", :d => rand(200) * 60}, {:v => "qq", :d => rand(150) * 60}, {:v => "textmate", :d => rand(100)*60}, {:v => "skype", :d => rand(100) * 60}],
             [{:v => "firefox", :d => rand(200) * 60}, {:v => "word", :d => rand(150) * 60}, {:v => "eclipse", :d => rand(100)*60}, {:v => "skype", :d => rand(100) * 60}],          
             [{:v => "firefox", :d => rand(200) * 60}, {:v => "qq", :d => rand(150) * 60}, {:v => "eclipse", :d => rand(100)*60}, {:v => "word", :d => rand(100) * 60}],
           ]
           result << {:t => (Time.now - i.days).to_i, :app => w[rand(3)]}
        }
        render :json => result.to_json
      else
        
        day = params[:q] =~ /from_last\((\d+)\*day\)/ ? $1.to_i : 0
          
        render :json => ClientEvent.day(day).to_json
      end
    end
  end
end
