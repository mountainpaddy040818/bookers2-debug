class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user,only: [:edit, :destroy, :update]

  def show
    @book = Book.find(params[:id])
    @book.increment!(:view_count)
    @user = @book.user
    @book_new = Book.new
    @book_comment = BookComment.new
    
  end

  def index
    @books = Book.all
    to = Time.current.at_end_of_day
    from = (to - 1.month).at_beginning_of_day
    @books = Book.includes(:favorites).sort_by {
      |book| -book.favorites.where(created_at: from...to).count
    }
    @book = Book.new
    @user = User.find(current_user.id)
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      flash[:notice] = "errors prohibited this obj from being saved;"
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      @books = Book.all
      flash[:notice] = "errors prohibited this obj from being saved:"
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user_id == current_user.id
      redirect_to books_path
    end
  end
end
