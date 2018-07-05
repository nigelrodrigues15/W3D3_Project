# == Schema Information
#
# Table name: visits
#
#  id           :bigint(8)        not null, primary key
#  user_id      :integer          not null
#  short_url_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#


class Visit < ApplicationRecord
  
  def self.record_visit!(user, short_url)
    Visit.create(user_id: user, short_url_id: short_url)
  end
  
  belongs_to :user,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User
    
  belongs_to :shortened_urls,
  primary_key: :id,
  foreign_key: :short_url_id,
  class_name: :ShortenedUrl
  
end
