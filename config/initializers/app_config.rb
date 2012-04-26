module UserLayer
  class Application < Rails::Application
    config.fb_key = "354005347975586"
    config.fb_secret = "80d38bf2b9853d6d592f8fbdf2f73a47"
    
    config.weibo_key = "4007265856"
    config.weibo_secret = "4145658cc566838be20eeef55ec32b0b"
  end
end