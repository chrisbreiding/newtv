# == Schema Information
#
# Table name: tvsource
#
#  id           :integer          not null, primary key
#  last_updated :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Tvsource < ActiveRecord::Base
  attr_accessible :last_updated

  def self.update(time)
    tvsource = self.first || self.new
    tvsource.update_attributes(last_updated: time)
  end

end
