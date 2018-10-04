class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
#    case params[:order]
#      when 'title', 'release_date'
#        @movies = Movie.all.order(params[:order])
#        @hilite = params[:order].to_sym
#      else
#        @movies = Movie.all
#        @hilite = nil
#    end
    session[:ratings] = params[:ratings] || session[:ratings] || Hash[@all_ratings.map { |rating| [rating, '1'] }]
    @selected_ratings = session[:ratings]
 
    @sort = params[:order]
    @movies = Movie.where(rating: @selected_ratings.keys).order(@sort)
    
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

end
