# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  short_url  :string
#  long_url   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, :user_id, presence: true
  
  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User
  
  has_many :visits,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Visit
    
  has_many :visitors,
    through: :visits,
    source: :user
    
  
  def self.make_entry(long_url, user_id)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create(long_url: long_url, user_id: user_id, short_url: short_url)
  end
  
  def num_clicks
    self.visits.length
  end
  
  def num_uniques
    self.visitors.distinct.length
  end
  
  def num_recent_uniques
  visits
    .select('user_id')
    .where('created_at > ?', 10.minutes.ago)
    .distinct
    .count
  end  
  
  private 
  
  def self.random_code
    url = SecureRandom.urlsafe_base64
    until !(ShortenedUrl.exists?(url))
      url = SecureRandom.urlsafe_base64
    end
    url
  end
  
end
