Factory.define :mobile_device do

end

Factory.define :feed do

end

Factory.define :user do |f|
  f.email "test@example.com"
  f.password "123456"
  f.password_confirmation "123456"
end

Factory.define :care do

end

Factory.define :app do |f|
  f.app_token "13455"
end

Factory.define :app_list do

end
