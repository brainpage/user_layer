task :generate_test_data => :environment do
  ClientEvent.delete_all
  ClientApp.delete_all
  
  apps = %w{firefox textmate QQ vmware word explorer}
  
  ti = Time.now
  
  1.upto(15000) do |i|
    time = ti - i.minutes
    next if time.hour > 2 and time.hour < 7
    
    rd = rand(5)
    if rd == 0
      event = ClientEvent.create(:point => rand(50), :created_at => time)
      
      if rd == 1
        event.client_apps.create(:dur => (per = rand(10) / 10.0), :keys => rand(50), :msclks => rand(20), :dst => rand(1000), :app => apps[rand(6)])
        event.client_apps.create(:dur => 1 - per, :keys => rand(50), :msclks => rand(20), :dst => rand(1000), :app => apps[rand(6)])
      else
        event.client_apps.create(:dur => 1, :keys => rand(50), :msclks => rand(20), :dst => rand(1000), :app => apps[rand(6)])
      end
    end
  end
  
  ProcessedData.delete_all
  %w{com.apple.Terminal org.vim.MacVim com.apple.dt.Xcode firefox com.google.chrome}.each do |t|
    %w{keys msclks scrll dst}.each do |i|
      ProcessedData.create(:category => "#{t}:#{i}", :value => rand(1000) + 200)
    end
  end
end