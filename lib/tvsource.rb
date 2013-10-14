module TvSource

  API_KEY = "9E252208882DCB14"
  BASE_URL = "http://thetvdb.com/api/"

  URLS = {
    show_search: "#{BASE_URL}GetSeries.php?seriesname=:show_name",
    show_zip: "#{BASE_URL}#{API_KEY}/series/:show_id/all/english.zip"
  }

	def self.sync(new_show = nil)
		require 'open-uri'
		require 'timeout'

		shows = new_show ? [new_show] : Show.all

 		shows.each do |show|
 			retries = 0

 			url = "#{BASE_URL}episode_list.php?sid=#{show[:tvsource_id]}"
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
				if show.episodes.any?
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

            unless details['title'].nil?
  						Episode.create(
  							show_id: show[:id],
  							season: season.get_attribute('no').to_i,
  							episode_number: details['seasonnum'],
  							title: details['title'],
  							airdate: details['airdate']
  						)
            end
					end
				end
			end
		end
	end

  def self.search(show_name)
    require 'open-uri'

    url = URLS[:show_search].sub(/:show_name/, show_name)
    xml = Nokogiri::XML(open(URI.escape(url)))

    attributes = %w{seriesid SeriesName Overview FirstAired Network}
    attributes = {
      "seriesid" => "id",
      "SeriesName" => "name",
      "Overview" => "overview",
      "FirstAired" => "started",
      "Network" => "network"
    }

    xml.xpath('//Series').collect do |show|
      details = {}

      show.children.each do |detail|
        if attributes.key?(detail.name)
          details[attributes[detail.name]] = detail.text
        end
      end

      attributes.each do |key, value|
        if !details.key?(value)
          details[value] = "unknown"
        end
      end

      details
    end
  end

end

# <Data>
#   <Series>
  #   <seriesid>74011</seriesid>
  #   <language>en</language>
  #   <SeriesName>Portraits: The Americans</SeriesName>
  #   <FirstAired>1997-09-01</FirstAired>
  #   <Network>PBS</Network>
  #   <zap2it_id>SH869211</zap2it_id>
  #   <id>74011</id>
#   </Series>
#   <Series>
#   <seriesid>76467</seriesid>
#   <language>en</language>
#   <SeriesName>Young Americans</SeriesName>
#   <banner>graphical/76467-g2.jpg</banner>
#   <Overview>
#   Young Americans, a spin-off of popular WB show Dawson's Creek stars Will Krudski (Rodney Scott) as he starts school at Rawley Academy and tries to catch up with the fact that he's out of his element. Together with his roommate, Scott Calhoun (Mark Famiglietti), they both long for Bella Banks (Kate Bosworth), a luminous local girl. Hamilton Fleming (Ian Somerhalder) is edgy and alternative, while his outside status attracts friendship of Jacqueline Pratt (Katherine Moennig). The show aired immediately after its parent series in the summer of 2000 and did extremely well in the ratings, but it never returned for a second season.
#   </Overview>
#   <FirstAired>2000-07-12</FirstAired>
#   <Network>The WB</Network>
#   <IMDB_ID>tt0220178</IMDB_ID>
#   <zap2it_id>SH380747</zap2it_id>
#   <id>76467</id>
#   </Series>
#   <Series>
#   <seriesid>82257</seriesid>
#   <language>en</language>
#   <SeriesName>The Native Americans</SeriesName>
#   <banner>graphical/82257-g.jpg</banner>
#   <Overview>
#   "The Native Americans" shows a culture that is not only an ancient and wise one, but that it still thriving today.
#   </Overview>
#   <Network>TNT</Network>
#   <IMDB_ID>tt0215431</IMDB_ID>
#   <id>82257</id>
#   </Series>
