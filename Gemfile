if `hostname` =~ /^ip/
  source 'http://rubygems.org'
else
  source 'http://ruby.taobao.org'
end

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'twitter-bootstrap-rails', '~>2.0'
#gem 'simple_form'
gem 'rest-client'
gem 'devise'
gem 'faraday'
gem 'faraday_middleware'
gem 'slim'
gem 'mysql'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'


# Gems used only for assets and not required
# in production environments by default.
gem 'omniauth'
#gem 'omniauth-twitter', :git => 'https://github.com/arunagw/omniauth-twitter.git'
#gem 'omniauth-google-oauth2', :git => 'https://github.com/zquestz/omniauth-google-oauth2.git'
gem 'omniauth-facebook'
gem 'omniauth-weibo-oauth2'
gem 'i18n-js'

gem 'capistrano'
gem 'therubyracer', :require => 'v8'

group :development, :test do  
  #gem 'mongrel', '>= 1.2.0.pre2'
  #gem 'capistrano'
  #gem 'sqlite3'
  # Pretty printed test output
  #gem 'turn', '0.8.2', :require => false
  #gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'rspec', '>=2.0.0'
  gem 'rspec-rails', '>=2.0.0'
  gem 'ZenTest', '~> 4.5.0'
  gem 'factory_girl_rails'
end

group :production do
#  gem 'mysql'
  gem 'unicorn'
end
