class LinkedinRecommendationsController < ApplicationController
  before_filter :authenticate_user!

  def import
    begin
      @client = LinkedIn::Client.new
      @client.authorize_from_access(session['linkedin.token'], session['linkedin.secret'])
      recommendations = @client.profile(:fields => %w(recommendations-received)).recommendations_received.all

      ActiveRecord::Base.transaction do
        recommendations.each do |recommendation|
          recommender_position = @client.profile(:id => recommendation.recommender.id , :fields => %w(positions)).positions.all[0]
          name = "#{recommendation.recommender.first_name} #{recommendation.recommender.last_name}"
          recommender_title = recommender_position.title
          recommender_company_name = recommender_position.company.name
          reco = Recommendation.new(name: name, title: recommender_position.title, company: recommender_position.company.name,
                                    photo_url: photo_url(recommendation.recommender.id), source: 'linkedin',
                                    ref_id: recommendation.recommender.id, recommendation: recommendation.recommendation_text)
          reco.user = current_user
          reco.save!
        end
      end
    rescue Exception => e
      logger.error "???? Something goes wrong #{e.message}"
      raise
    end
    redirect_to :root
  end

  private
    def photo_url(recommender_id)
      lin_img_url_resp = @client.profile(:id => recommender_id, :fields => %w(picture-urls::(original)))
      unless lin_img_url_resp.blank? && lin_img_url_resp.picture_urls.blank?
        pic_urls = lin_img_url_resp.picture_urls
        pic_urls.all[0] if pic_urls.total > 0
      end
    end
end
