class Visit < ActiveRecord::Base
  belongs_to(
    :visitor,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: "User"
  )

  belongs_to(
    :visited_url,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: "ShortenedUrl"
  )

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user, shortened_url_id: shortened_url)
  end


end
