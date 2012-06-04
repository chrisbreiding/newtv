class Show < ActiveRecord::Base
	validates_presence_of :name, :tvrage_id
	has_many :episodes, dependent: :destroy

  def next_episodes_airdate
    i = 0
    while episodes[i] && episodes[i].airdate < 1.day.ago.to_date
      # if there was a recently aired episode, but no scheduled future episodes
      return 1.month.from_now.to_date if !episodes[i + 1]
      i += 1
    end
    episodes[i].airdate
  end
end