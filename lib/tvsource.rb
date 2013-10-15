module TvSource

  BASE_URL = "http://thetvdb.com/api/"
  API_KEY = "41066016732D1E20"

  URLS = {
    show_search: "#{BASE_URL}GetSeries.php?seriesname=:show_name",
    show_zip: "#{BASE_URL}#{API_KEY}/series/:show_id/all/en.zip"
  }

  def self.sync
    Show.all.each do |show|
      add_episodes_for_show(show)
    end
  end

  def self.update_episodes_for_show(show)
    require 'open-uri'
    require 'timeout'

    retries = 0
    url = URLS[:show_zip].sub(/:show_id/, show[:tvsource_id])

    Rails.logger.debug show.name
    begin
      Timeout::timeout(20) do
        Rails.logger.debug "... grabbing xml - attempt ##{retries + 1}"
        remote_data = open(url).read
        local_file = open("#{Rails.root}/en.zip", "wb")
        local_file.write(remote_data)
        local_file.close
      end
    rescue Timeout::Error
      retries += 1
      if retries <= 15
        sleep 5 and retry
      else
        Rails.logger.debug "!.. failed after 15 attempts"
        raise
      end
    end

    xml = Nokogiri::XML(show_xml_from_zip)

    if !xml.nil?
      if show.episodes.any?
        Rails.logger.debug "... deleting episodes"
        show.episodes.delete_all
      end

      Rails.logger.debug "... creating episodes"
      xml.css('Episode').each do |episode|
        season         = episode.css('SeasonNumber')
        episode_number = episode.css('EpisodeNumber')
        title          = episode.css('EpisodeName')
        airdate        = episode.css('FirstAired')

        Episode.create(
          show_id:        show[:id],
          season:         season.empty? ? 9999 : season[0].text,
          episode_number: episode_number.empty? ? 9999 : episode_number[0].text,
          title:          title.empty? ? '' : title[0].text,
          airdate:        airdate.empty? ? '1970-01-01' : airdate[0].text
        )
      end
    else
      Rails.logger.debug "!.. xml was nil"
    end
  end

  def self.show_xml_from_zip
    require 'zip'
    Zip::File.open("#{Rails.root}/en.zip").read('en.xml')
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
