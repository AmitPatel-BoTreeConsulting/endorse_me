class Recommendation < ActiveRecord::Base
  attr_accessible :name, :title, :company, :photo_url, :recommendation, :source, :ref_id

  belongs_to :user
end
