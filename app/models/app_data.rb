# == Schema Information
#
# Table name: app_data
#
#  id            :integer          not null, primary key
#  last_updated  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  download_link :string(255)
#

class AppData < ActiveRecord::Base
  attr_accessible :last_updated, :download_link

  def self.update_time(time)
    self.instance.update_attributes(last_updated: time)
  end

  def self.last_updated
    self.instance.last_updated || Date.new
  end

  def self.update_download_link(link)
    self.instance.update_attributes(download_link: link)
  end

  def self.download_link
    self.instance.download_link || ''
  end

  private

    def self.instance
      self.first || self.new
    end

end
