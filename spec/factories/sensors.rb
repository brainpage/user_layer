# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sensor do
    stype 'computer'
    uuid "12345"
  end
end
