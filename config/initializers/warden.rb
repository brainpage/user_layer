Warden::Manager.after_set_user :except => :fetch do |record, warden, options|
  puts "HI WORLD INSIDE WARDEN==========="
end
