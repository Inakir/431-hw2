class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #changes the way the movies are indexed
  def index
    @all_ratings = Movie.all_ratings

    #filters the results
    @ratings = params[:ratings]
    if(@ratings !=nil)
      @movies = Movie.where("rating in (?)", @ratings.keys)
      session[:ratings] = @ratings
    elsif(session[:ratings] != nil)
      @movies = Movie.where("rating in (?)", session[:ratings].keys)
    else
      @movies = Movie.all
    end

    #this right here is a fancy sort
    if (params[:sort] == "title")
      @movies = @movies.sort_by {|movie| movie.title}
      session[:sort] = params[:sort]
    elsif(params[:sort] == "release_date")
      @movies = @movies.sort_by {|movie| movie.release_date}
      session[:sort] = params[:sort]
    elsif (session[:sort] == "title")
        @movies = @movies.sort_by {|movie| movie.title}
    elsif(session[:sort] == "release_date")
        @movies = @movies.sort_by {|movie| movie.release_date}
    end

    @stored_ratings = session[:ratings]
    #@movies = @movies.select {|movie| movie[:rating] == 'PG-13' }
    #end fancy sort


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
