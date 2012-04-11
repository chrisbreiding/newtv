class Show < ActiveRecord::Base
	validates_presence_of :name, :tvrage_id
	has_many :episodes, dependent: :destroy		
	
	def next_episode
		if Time.parse(self.episodes[0].airdate.to_s) < 1.day.ago
			i = 1
			i += 1 while Time.parse(self.episodes[i].airdate.to_s) < 1.day.ago
			next_ep = self.episodes[i].airdate
		else
			next_ep = self.episodes[0].airdate
		end
		next_ep
	end

end