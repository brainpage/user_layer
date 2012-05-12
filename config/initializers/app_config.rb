module UserLayer
  class Application < Rails::Application
    config.base_url = "http://www.brainpage.com/"
    config.base_url_zh = "http://app.brainpage.cn/"
    
    config.fb_key = "354005347975586"
    config.fb_secret = "80d38bf2b9853d6d592f8fbdf2f73a47"
    config.fb_send_url = "http://www.facebook.com/dialog/send"
    
    config.weibo_key = "1004180194"
    config.weibo_secret = "da1d562d1b5ae8e7524c19fc238503a5"
    config.weibo_create_url = "https://api.weibo.com/2/statuses/update.json"
  end
end