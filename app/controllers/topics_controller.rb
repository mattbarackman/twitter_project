class TopicsController < ApplicationController


  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @topic}
    end
  end
end