# frozen_string_literal: true

module Commentable
  extend ActiveSupport::Concern

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      flash[:alert] = @comment.errors.full_messages.join
      on_save_error
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @commentable = @comment.commentable

    @comment.destroy
    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
