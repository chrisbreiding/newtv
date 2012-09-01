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

require 'spec_helper'

describe Episode do

  before { @episode = FactoryGirl.create(:episode) }
  subject { @episode }

  it { should respond_to(:season) }
  it { should respond_to(:episode_number) }
  it { should respond_to(:title) }
  it { should respond_to(:show_id) }
  it { should respond_to(:airdate) }
  it { should respond_to(:show) }

  it { should be_valid }

  describe "episode number" do
    before do
      @episode.season = 1
      @episode.episode_number = '01'
    end

    its(:epnum) { should == '101' }
  end

  describe "file safe title" do
    before { @episode.title = 'What? a *title*: so punc/tuated & $super!' }

    its(:filesafe_title) { should == 'What a title - so punc-tuated and super' }
  end

  describe "properly capitalized title" do
    before do
      @episode.title = 'Of of Etc etc And and By by The the For for Is is At at To to But but Nor nor Or or A a An an Via via TBA tba'
    end

    its(:proper_title) { should == 'Of of etc etc and and by by the the for for is is at at to to but but nor nor or or a a an an via via TBA TBA' }
  end

end