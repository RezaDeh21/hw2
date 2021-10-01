class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings=['G','PG','PG-13','R']
      # put ratings into a hash to achive currect checkbox fields
      hashed_ratings=Hash[@all_ratings.map {|rating| [rating, rating]}]
      
      # Implimentation for part 1.1: Sort by Title || Release Date
      # session[] used to remember sesssions and to if all filters are unchecked
      if params[:sort]
        @sort_by=params[:sort] 
      else @sort_by=session[:sort] 
      end
      
      # Implimentation for part 2.1: filter by rating
      if params[:ratings]
        @picked_ratings=session[:ratings]=params[:ratings] 
      else 
        if session[:ratings] 
          @picked_ratings=session[:ratings] 
        else @picked_ratings=hashed_ratings
        end  
      end
      
      # Implimentation for part 1.2, 2.2, 3:
      if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
        session[:ratings]=@picked_ratings
        session[:sort]=@sort_by
        flash.keep
        # redirect to new URI containing the appropriate parameters
        redirect_to movies_path(sort: @sort_by , ratings: @picked_ratings)
      end
      
      @movies = Movie.where(rating: @picked_ratings.keys)
      @movies = @movies.order(@sort_by) 
      
      
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