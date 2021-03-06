# == Schema Information
#
# Table name: episodes
#
#  id             :integer          not null, primary key
#  season         :integer
#  episode_number :string(255)
#  title          :string(255)
#  show_id        :integer
#  airdate        :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Episode < ActiveRecord::Base
	belongs_to :show
  attr_accessible :season, :episode_number, :title, :show_id, :airdate

  before_save :adjust_episode_number
  default_scope order: 'airdate ASC'
  scope :upcoming, -> { where('airdate > ?', 1.day.ago.to_date) }
  scope :recent, -> { where('airdate > ? AND airdate < ?', 5.days.ago.to_date, Date.today) }

  def filesafe_title
    title
      .gsub(/[\/]/, '-')
      .gsub(/\:\s+/, ' - ')
      .gsub(/\&/, 'and')
      .gsub(/[\.\!\?\@\#\$\%\^\*\:]/, '')
  end

  def proper_title
    lowercase = %w{Of of Etc etc And and By by The the For for Is is At at To to But but Nor nor Or or A a An an Via via}
    uppercase = %{TBA tba II ii III iii IV iv}

    filesafe_title.split(' ').each_with_index.collect { |word, i|
      if lowercase.include?(word) && i > 0
        word.downcase
      elsif uppercase.include?(word)
        word.upcase
      else
        word.capitalize
      end
    }.join(' ')
  end

  private

    def adjust_episode_number
      if self.episode_number.length < 2
        self.episode_number = "0#{self.episode_number}"
      end
    end

end
