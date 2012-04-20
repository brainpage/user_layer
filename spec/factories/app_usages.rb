# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app_usage do
    date "2012-04-19 23:47:19"
    app "MyString"
    dur 1
    user_id 1
  end
end
