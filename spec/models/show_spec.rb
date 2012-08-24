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

require 'spec_helper'

describe Show do

  before { @show = FactoryGirl.create(:show) }
  subject { @show }

  it { should respond_to(:name) }
  it { should respond_to(:tvrage_id) }
  it { should respond_to(:seasons) }
  it { should respond_to(:episodes) }
  it { should respond_to(:next_episodes_airdate) }

  it { should be_valid }

  describe "when name is not present" do
    before { @show.name = "" }
    it { should_not be_valid }
  end

  describe "when tvrage id is not present" do
    before { @show.tvrage_id = "" }
    it { should_not be_valid }
  end

  describe "when name has tags in it" do
    it "strips out tags" do
      @show.name = '<script src="malicious">code</script>'
      @show.save
      @show.name.should == 'code'
    end
  end

  describe "associated episodes" do
    before do
      Show.destroy_all

      @show1 = FactoryGirl.create(:show, name: "Show 1")
      @year_old_episode = FactoryGirl.create(:year_old_episode, show: @show1, season: 1)
      @two_day_old_episode = FactoryGirl.create(:two_day_old_episode, show: @show1, season: 2)
      @episode_airing_in_2_days = FactoryGirl.create(:episode_airing_in_2_days, show: @show1, season: 2)
    end

    it "destroys associated episodes" do
      episodes = @show1.episodes
      @show1.destroy
      episodes.each do |episode|
        Episode.find_by_id(episode.id).should be_nil
      end
    end

    context "that are upcoming" do
      it "has episodes 3 days old or newer" do
        Show.upcoming.first.episodes.should == [@two_day_old_episode, @episode_airing_in_2_days]
      end
    end

    context "that are upcoming" do
      before do
        @show2 = FactoryGirl.create(:show)
        @episode_airing_tomorrow = FactoryGirl.create(:episode_airing_tomorrow, show: @show2)
      end

      it "orders shows by next episode" do
        Show.upcoming.should == [@show2, @show1]
      end
    end

    context "that are not upcoming" do
      before do
        @show3 = FactoryGirl.create(:show)
        @months_old_episode = FactoryGirl.create(:months_old_episode, show: @show3)
      end

      it "has shows with only old episodes" do
        Show.off_air.should == [@show3]
      end
    end

    context "listing all" do
      it "groups episodes by season" do
        @show1.episodes_by_season.should == {
          1 => [@year_old_episode],
          2 => [@two_day_old_episode, @episode_airing_in_2_days]
        }
      end
    end
  end

  describe "search" do
    it "returns an array" do
      Show.search('Cheers').should be_a_kind_of(Array)
    end

    it "returns an array of hashes" do
      Show.search('Cheers')[0].should be_a_kind_of(Hash)
    end

    it "returns an array of hashes with the right keys" do
      Show.search('Cheers')[0].keys.should =~ %w{showid country name started seasons classification}
    end
  end

  describe "next episode's airdate" do
    context "when there is a recently aired episode" do
      before { FactoryGirl.create(:two_day_old_episode, show: @show) }

      context "with future episodes" do
        before { FactoryGirl.create(:episode_airing_tomorrow, show: @show) }
        its(:next_episodes_airdate) { should == 1.day.from_now.to_date }
      end

      context "with no future episodes" do
        its(:next_episodes_airdate) { should == 1.month.from_now.to_date }
      end
    end

    context "when there are no recently aired episodes" do
      before { FactoryGirl.create(:year_old_episode, show: @show) }

      context "with future episodes" do
        before { FactoryGirl.create(:episode_airing_tomorrow, show: @show) }
        its(:next_episodes_airdate) { should == 1.day.from_now.to_date }
      end

      context "with no future episodes" do
        its(:next_episodes_airdate) { should == 1.month.from_now.to_date }
      end
    end
  end

end
