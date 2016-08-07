class TopicsController < ApplicationController


  def index
    @topics = Topic.where(:name => ["@HillaryClinton", "@realDonaldTrump"])
  end

  def show
    @topic = Topic.find(params[:id])
  end

end