FactoryGirl.define do

  sequence(:ep_num) do |n|
    if n < 10
      "0#{n}}"
    else
      "#{n}"
    end
  end

  factory :show do
    sequence(:name)      { |n| "Show#{n}" }
    sequence(:tvrage_id) { |n| n }
  end

  factory :episode do
    sequence(:title) {|n| "Episode#{n}" }
    season           1
    episode_number   { generate(:ep_num) }
    airdate          3.years.ago.to_date..Date.today
    show

    factory :year_old_episode do
      airdate 1.year.ago.to_date
    end

    factory :months_old_episode do
      airdate 5.months.ago.to_date
    end

    factory :two_day_old_episode do
      airdate 2.days.ago.to_date
    end

    factory :episode_airing_tomorrow do
      airdate 1.day.from_now.to_date
    end

    factory :episode_airing_in_2_days do
      airdate 2.days.from_now.to_date
    end
  end

end