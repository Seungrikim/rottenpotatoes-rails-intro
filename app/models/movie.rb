class Movie < ActiveRecord::Base
  @all_ratings = Array['G','PG','PG-13','R']
  def self.all_ratings
    @all_ratings
  end
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    Movie.where(rating: ratings_list)
  end
  def self.with_title
    Movie.order('title asc')
  end
  def self.with_release_date
    Movie.order('release_date asc')
  end
end
