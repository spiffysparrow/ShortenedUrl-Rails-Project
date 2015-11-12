class ShortenedUrl < ActiveRecord::Base
  # validates :short_url, uniqueness: true
  validates :long_url, presence: true
  validates :submitter_id, presence: true

  belongs_to(
    :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: "User"
  )

  has_many(
    :visits,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: "Visit"
  )

  has_many(
    :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor
  )

  def self.random_code
    all_shortened_urls = ShortenedUrl.all.map { |shortened_url| shortened_url.short_url }

    new_rand_code = nil
    while all_shortened_urls.include?(new_rand_code) || new_rand_code.nil?
      new_rand_code = SecureRandom.urlsafe_base64
    end

    new_rand_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(short_url: short_url, long_url: long_url, submitter_id: user)
  end

  def num_clicks
    Visit.where(shortened_url_id: id).select("user_id").count
  end

  def num_recent_clicks
    Visit.where("shortened_url_id = ? AND created_at < ?", 2, 10.minutes.ago).select("user_id").distinct.count
  end
end
