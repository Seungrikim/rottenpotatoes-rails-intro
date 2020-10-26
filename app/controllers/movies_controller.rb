class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @ratings_to_show = params[:ratings].keys
      session[:filtered_rating] = @ratings_to_show
    elsif session[:filtered_rating]
      query = Hash.new
      session[:filtered_rating].each do |rating|
        query['ratings['+ rating + ']'] = 1
      end
      query['sort'] = params[:sort] if params[:sort]
      session[:filtered_rating] = nil
      flash.keep
      redirect_to movies_path(query)
    else
      @ratings_to_show = @all_ratings
    end

    @movies.where!(rating: @ratings_to_show)

    case params[:sort]
    when 'title'
      @movies.order!('title asc')
      @title_class = "hilite"
    when 'release_date'
      @movies.order!('release_date asc')
      @release_date_class = "hilite"
    end
    """redirect = false
    if params[:sort]
      @sorting = session[:sort]
    elsif session[:sort]
      @sorting = session[:sort]
      redirect = true
    end
    
    if params[:ratings]
      @ratings_to_show = params[:ratings]
    elsif session[:ratings]
      @ratings_to_show = session[:ratings]
      redirect = true
    else
      @all_ratings.each do |rat|
        (@ratings_to_show ||= { })[rat] = 1
      end
      redirect = true
    end
    if redirect
      redirect_to movies_path(:sort => @sorting, :ratings => @ratings_to_show)
    end
    
    @moives = Movie.where(rating: @ratings_to_show)
    
    Movie.find(:all, :order => @sorting ? @sorting : :id).each do |mv|
      if @ratings_to_show.keys.include? mv[:rating]
        (@movies ||= [ ]) << mv
      end
    end
    session[:sort] = @sorting
    session[:ratings] = @ratings_to_show"""
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
