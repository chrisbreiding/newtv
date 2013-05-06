# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tvrage_id  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  seasons    :integer
#

class Show < ActiveRecord::Base
	validates_presence_of :name, :tvrage_id
	has_many :episodes, dependent: :destroy
  attr_accessible :name, :tvrage_id, :seasons
  before_validation :clean_input

  def self.upcoming
    includes(:episodes).where('episodes.airdate > ?', 1.day.ago.to_date).sort! do |a,b|
        a.next_episodes_airdate <=> b.next_episodes_airdate
      end
  end

  def self.recent
    includes(:episodes).where('episodes.airdate > ? AND episodes.airdate < ?', 4.days.ago.to_date, Date.today).order 'episodes.airdate ASC'
  end

  def self.off_air
    upcoming_shows = Show.upcoming
    @off_air = Show.order('name').keep_if do |show|
      upcoming_shows.select { |s| s.name == show.name }.empty?
    end
  end

  def self.search show_name
    tvrage_xml = search_tvrage(show_name)

    attributes = %w{showid country name started seasons classification}

    tvrage_xml.xpath('//show').collect do |show|
      details = {}

      show.children.each do |detail|
        if attributes.index detail.name
          details[detail.name] = detail.text
        end
      end

      details
    end
  end

  def episodes_by_season
    episodes.group_by { |ep| ep.season }
  end

  def next_episodes_airdate
    episodes.sort_by! &:airdate
    i = 0
    while episodes[i] && episodes[i].airdate < 1.day.ago.to_date
      # if there was a recently aired episode, but no scheduled future episodes
      return 1.month.from_now.to_date if !episodes[i + 1]
      i += 1
    end
    episodes[i].airdate
  end

  private

    def self.search_tvrage show_name
      require 'open-uri'
      url = "http://services.tvrage.com/feeds/search.php?show=#{URI.escape(show_name)}"
      Nokogiri::XML(open(url))
    end

    def clean_input
      self.name = ActionController::Base.helpers.strip_tags self.name
    end

end
