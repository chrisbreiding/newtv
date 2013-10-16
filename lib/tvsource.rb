module TvSource
  require 'open-uri'

  BASE_URL = "http://thetvdb.com/api/"
  API_KEY = "41066016732D1E20"

  URLS = {
    show_search:        "#{BASE_URL}GetSeries.php?seriesname=:show_name",
    show_zip:           "#{BASE_URL}#{API_KEY}/series/:show_id/all/en.zip",
    current_time:       "#{BASE_URL}/Updates.php?type=none",
    updated_since_time: "#{BASE_URL}/Updates.php?type=all&time=:last_updated"
  }

  def self.sync
    updated_show_ids, time = updated_shows_and_time.values_at(:show_ids, :time)
    Show.all.each do |show|
      if updated_show_ids.include?(show.tvsource_id)
        add_episodes_for_show(show)
      end
    end
    Tvsource.update(time)
  end

  def self.update_episodes_for_show(show)
    require 'timeout'

    Rails.logger.debug show.name

    download_url( URLS[:show_zip].sub(/:show_id/, show[:tvsource_id]) )
    xml = Nokogiri::XML(show_xml_from_zip)

    if !xml.nil?
      if show.episodes.any?
        Rails.logger.debug "... deleting episodes"
        show.episodes.delete_all
      end

      Rails.logger.debug "... creating episodes"
      xml.css('Episode').each do |episode|
        details = details_for_episode(episode)
        details[:show_id] = show[:id]
        Episode.create(details)
      end
    else
      Rails.logger.debug "!.. xml was nil"
    end
  end

  def self.search(show_name)
    url = URLS[:show_search].sub(/:show_name/, show_name)
    xml = Nokogiri::XML(open(URI.escape(url)))

    shows = xml.xpath('//Series').collect do |show|
      details_for_show(show)
    end

    shows.sort do |a, b|
      Date.parse(b[:started]) <=> Date.parse(a[:started])
    end
  end

  def self.set_initial_tvsource_time
    xml = Nokogiri::XML(open(URI.escape(URLS[:current_time])))
    Tvsource.update(xml.css('Time')[0].text.to_i)
  end

  private

    def self.download_url(url)
      retries = 0
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
    end

    def self.show_xml_from_zip
      require 'zip'
      Zip::File.open("#{Rails.root}/en.zip").read('en.xml')
    end

    def self.details_for_show(show)
      attributes = [
        { selector: 'seriesid',   property: :id,       default: ''           },
        { selector: 'SeriesName', property: :name,     default: 'Unknown'    },
        { selector: 'Overview',   property: :overview, default: ''           },
        { selector: 'FirstAired', property: :started,  default: '1970-01-01' },
        { selector: 'Network',    property: :network,  default: ''           }
      ]
      details_for_node(show, attributes)
    end

    def self.details_for_episode(episode)
      attributes = [
        { selector: 'SeasonNumber',  property: :season,         default: 0            },
        { selector: 'EpisodeNumber', property: :episode_number, default: '00'         },
        { selector: 'EpisodeName',   property: :title,          default: ''           },
        { selector: 'FirstAired',    property: :airdate,        default: '1970-01-01' }
      ]
      details_for_node(episode, attributes)
    end

    def self.details_for_node(node, attributes)
        details = {}
        attributes.each do |attribute|
          detail = node.css(attribute[:selector])
          details[attribute[:property]] = if detail.empty?
            attribute[:default]
          else
            detail[0].text
          end
        end
        details
    end

    def self.updated_shows_and_time
      url = URLS[:updated_since_time].sub(/:last_updated/, Tvsource.first.last_updated.to_s)
      xml = Nokogiri::XML(open(URI.escape(url)))
      {
        show_ids: xml.css('Series').collect(&:text),
        time:      xml.css('Time')[0].text.to_i
      }
    end

end
