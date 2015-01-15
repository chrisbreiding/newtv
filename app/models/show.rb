# == Schema Information
#
# Table name: shows
#
#  id           :integer          not null, primary key
#  display_name :string(255)
#  tvsource_id  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  search_name  :text
#  file_name    :text
#

class Show < ActiveRecord::Base
	validates_presence_of :display_name, :search_name, :file_name, :tvsource_id
	has_many :episodes, dependent: :destroy
  attr_accessible :display_name, :search_name, :file_name, :tvsource_id, :seasons
  before_validation :clean_input

  def self.upcoming
    includes(:episodes).where('episodes.airdate > ?', 1.day.ago.to_date).sort! do |a,b|
      a.next_episodes_airdate <=> b.next_episodes_airdate
    end
  end

  def self.recent
    includes(:episodes).where('episodes.airdate > ? AND episodes.airdate < ?', 5.days.ago.to_date, Date.today).order 'episodes.airdate DESC'
  end

  def self.off_air
    upcoming_shows = Show.upcoming
    @off_air = Show.order('display_name').keep_if do |show|
      upcoming_shows.select { |s| s.id == show.id }.empty?
    end
  end

  def self.search show_name
    require 'tvsource'
    TvSource.search(show_name)
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

  def download_link
    AppData.download_link.gsub(/%s/, search_name)
  end

  private

    def clean_input
      self.display_name = ActionController::Base.helpers.strip_tags self.display_name
      self.search_name = ActionController::Base.helpers.strip_tags self.search_name
      self.file_name = ActionController::Base.helpers.strip_tags self.file_name
    end

end
