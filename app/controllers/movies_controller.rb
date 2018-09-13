# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    #@movies = Movie.all

    @ratings_filter = (session[:ratings].keys if session.key?(:ratings)) || @all_ratings
    @movies = Movie.order(params[:sort]).where(rating: @ratings_filter)

    @all_ratings = Movie.all_ratings.sort

    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
    elsif session.has_key?(:ratings)
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to movies_path(params.permit!) and return
    end

    if params[:sort] == 'title'
      session[:sort] = params[:sort]
    elsif params[:sort] == 'release_date'
      session[:sort] = params[:sort]
    elsif session.key?(:sort)
      params[:sort] = session[:sort]
      flash.keep
      redirect_to movies_path(params.permit(:sort, :ratings)) and return
    end
    
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end