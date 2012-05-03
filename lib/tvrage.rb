module TvRage

	def self.sync(new_show = nil)
		require 'open-uri'

    puts "deleting episodes..."
		Episode.delete_all if new_show.nil?

		shows = new_show ? [new_show] : Show.all

 		shows.each do |show|
			xml = Nokogiri::XML(open("http://services.tvrage.com/feeds/episode_list.php?sid=#{show[:tvrage_id]}"))

      puts "updating #{show.name}..."

      puts "updating number of seasons"
			# update show with latest season
			show.update_attributes seasons: xml.xpath('//totalseasons').text

      puts "updating episodes"
			# add all the episodes
			xml.xpath('//Season').each do |season|
				season.children.each do |episode|
					details = {}
					episode.children.each do |detail|
						details[detail.name] = detail.text
					end

					Episode.create(
						show_id:		show[:id],
						season: 		season.get_attribute('no').to_i,
						episode_number: details['seasonnum'],
						title: 			details['title'],
						airdate: 		details['airdate']
					) unless details['title'].nil?
				end
			end
		end
	end

end