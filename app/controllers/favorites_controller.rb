class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @book.favorites.create(user_id: current_user.id)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @book = Book.find(params[:book_id])
    @book.favorites.find_by(user_id: current_user.id).destroy
    redirect_back(fallback_location: root_path)
  end
end