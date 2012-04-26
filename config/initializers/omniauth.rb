Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, "LnNLVX9p4nLJlmaVn7jadA", "UV4Yg5JRYGBWSqsMFQkCgzphRvq1L1tRArgPb00" 
  #provider :google_oauth2, '505891327705.apps.googleusercontent.com', 'HAljpakXY0M7FtjlhX1IJFkQ', {access_type: 'online', approval_prompt: ''}
  provider :facebook, Rails.configuration.fb_key, Rails.configuration.fb_secret
  provider :weibo, Rails.configuration.weibo_key, Rails.configuration.weibo_secret
end
