class FavoritesController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @book.favorites.create(user_id: current_user.id)
  end

  def destroy
    @book = Book.find(params[:book_id])
    @book.favorites.find_by(user_id: current_user.id).destroy
  end
end