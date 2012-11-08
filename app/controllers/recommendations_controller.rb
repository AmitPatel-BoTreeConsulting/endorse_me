class RecommendationsController < ApplicationController
  #before_filter :authenticate_user!
  def index
    @recommendations = Recommendation.where(user_id: current_user.id) if user_signed_in?
  end
end
