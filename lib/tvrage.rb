module TvRage

	def self.sync(new_show = nil)
		require 'open-uri'
		require 'timeout'

		shows = new_show ? [new_show] : Show.all

 		shows.each do |show|
 			retries = 0

 			url = "http://services.tvrage.com/feeds/episode_list.php?sid=#{show[:tvrage_id]}"
 			file = false

			puts show.name 
			begin
				Timeout::timeout(20) do
					puts "... grabbing xml - attempt ##{retries + 1}"
					file = open(url)
				end
			rescue Timeout::Error
				retries += 1
				if retries <= 15
					sleep 5 and retry
				else
					puts "!.. failed after 15 attempts"
					raise
				end
			end

			if file
				if !show.episodes.empty?
			    puts "... deleting episodes"
					show.episodes.delete_all
				end

				xml = Nokogiri::XML(file)

	      puts "... updating number of seasons"
				# update show with latest season
				show.update_attributes seasons: xml.xpath('//totalseasons').text

	      puts "... updating episodes"
				# add all the episodes
				xml.xpath('//Season').each do |season|
					season.children.each do |episode|
						details = {}
						episode.children.each do |detail|
							details[detail.name] = detail.text
						end

						Episode.create(
							show_id: show[:id],
							season: season.get_attribute('no').to_i,
							episode_number: details['seasonnum'],
							title: details['title'],
							airdate: details['airdate']
						) unless details['title'].nil?
					end
				end
			end
		end
	end

end