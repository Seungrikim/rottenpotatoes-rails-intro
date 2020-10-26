class Movie < ActiveRecord::Base
  def self.all_ratings
    pluck('DISTINCT rating').sort!
  end
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    Movie.where(rating: ratings_list)
  end
  def self.with_title
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    Movie.order!('title asc')
  end
  def self.with_release_date
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    Movie.order!('release_date asc')
  end
end
