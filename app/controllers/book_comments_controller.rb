class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @book_comment = BookComment.new(comment_params)
    @book_comment.user_id = current_user.id
    @book_comment.book_id = @book.id
    unless @book_comment.save
      render 'error'
    end
  end

  def destroy
    book_comment = BookComment.find_by(book_id: params[:book_id], id: params[:id])
    if book_comment.user_id == current_user.id
      book_comment.destroy
      flash[:success] = "コメントが削除されました"
    else
      flash[:error] = "自分のコメントではないため、削除できません"
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:book_comment).permit(:comment, :user_id, :book_id)
  end
end