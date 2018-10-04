class Movie < ActiveRecord::Base
  def self.ratings
    Movie.pluck(:rating).uniq
  end
end
