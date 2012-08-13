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

  def epnum
    season.to_s + episode_number
  end

  def proper_title
    lowercase = %w{Of of Etc etc And and By by The the For for Is is At at To to But but Nor nor Or or A a An an Via via}
    uppercase = %{TBA tba}
    title.split(' ').each_with_index.collect { |word, i|
      if lowercase.include?(word) && i > 0
        word.downcase
      elsif uppercase.include?(word)
        word.upcase
      else
        word.capitalize
      end
    }.join(' ')
  end

  def filesafe_title
      proper_title.gsub(/[\.\!\?\@\#\$\%\^\&\*]/, '')
  end

end
