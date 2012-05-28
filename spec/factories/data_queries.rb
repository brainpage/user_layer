# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_query do
    name "test"
    query_clause "select"
  end
end
