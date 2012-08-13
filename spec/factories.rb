FactoryGirl.define do
  factory :show do
    sequence(:name) { |n| "Show #{n}" }
    tvrage_id       Random.rand(1..99)
  end

  factory :episode do
    sequence(:title) { |n| "Episode #{n}" }
    season           Random.rand(1..5)
    episode_number   Random.rand(1..24)
    airdate          3.years.ago.to_date..Date.today
    show
  end
end