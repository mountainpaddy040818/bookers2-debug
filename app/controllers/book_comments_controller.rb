class BookCommentsController < ApplicationController

  def create
    @book_comment = BookComment.new(comment_params)
    if @book_comment.save
      flash[:success] = "コメントが作成されました"
    else
      flash[:error] = "コメントの作成に失敗しました"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @book_comment = BookComment.find(params[:id])
    if @book_comment.user_id == current_user.id
      @book_comment.destroy
      flash[:success] = "コメントが削除されました"
    else
      flash[:error] = "自分のコメントではないため、削除できません"
    end
    redirect_back(fallback_location: root_path)
  rescue
    flash[:error] = "コメントの削除に失敗しました"
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:book_comment).permit(:content, :user_id, :book_id)
  end
end