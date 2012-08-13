FactoryGirl.define do
  factory :show do
    sequence(:name)      { |n| "Show #{n}" }
    sequence(:tvrage_id) { |n| n }
  end

  factory :episode do
    sequence(:title)          { |n| "Episode #{n}" }
    sequence(:season)         { |n| n }
    sequence(:episode_number) { |n| n }
    airdate                   3.years.ago.to_date..Date.today
    show
  end
end