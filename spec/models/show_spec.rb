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

  it { should be_valid }

  describe "when name is not present" do
    before { @show.name = "" }
    it { should_not be_valid }
  end

  describe "when tvrage id is not present" do
    before { @show.tvrage_id = "" }
    it { should_not be_valid }
  end

  describe "input cleaning" do
    it "should strip out tags from name" do
      @show.name = '<script src="malicious">code</script>'
      @show.save
      @show.name.should == 'code'
    end
  end

  describe "associated episodes" do
    FactoryGirl.create_list(:episode, 3, show: @show)

    it "should destroy associated episodes" do
      episodes = @show.episodes
      @show.destroy
      episodes.each do |episode|
        Episode.find_by_id(episode.id).should be_nil
      end
    end
  end

  describe "with upcoming episodes" do
    let!(:show) { FactoryGirl.create(:show) }
    let!(:old_episode) do
      FactoryGirl.create(
        :episode,
        show: show,
        airdate: 1.year.ago.to_date
      )
    end
    let!(:recent_episode) do
      FactoryGirl.create(
        :episode,
        show: show,
        airdate: 1.day.ago.to_date
      )
    end
    let!(:upcoming_episode) do
      FactoryGirl.create(
        :episode,
        show: show,
        airdate: 1.day.from_now.to_date
      )
    end

    it "should have episodes 3 days old or newer" do
      Show.upcoming.first.episodes.should_not include(old_episode)
    end
  end

  describe "with no upcoming episodes" do
    pending
  end

  describe "with all episodes" do
    pending
  end

  describe "search TVRage" do
    pending
  end

  describe "next episode's airdate" do
    describe "when there is a recently aired episode" do
      describe "with future episodes" do
        pending
      end

      describe "with no future episodes" do
        pending
      end
    end

    describe "when there are no recently aired episodes" do
      pending
    end
  end

end
