class Show < ActiveRecord::Base
	validates_presence_of :name, :tvrage_id
	has_many :episodes, dependent: :destroy

  def next_episodes_airdate
    i = 0
    while self.episodes[i] && Time.parse(self.episodes[i].airdate.to_s) < 1.day.ago
      # if there was a recently aired episode, but no scheduled future episodes
      return Time.parse 1.month.from_now.to_s if !self.episodes[i + 1]
      i += 1
    end
    Time.parse self.episodes[i].airdate.to_s
  end
end