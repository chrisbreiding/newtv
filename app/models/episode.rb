class Episode < ActiveRecord::Base
	belongs_to :show

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