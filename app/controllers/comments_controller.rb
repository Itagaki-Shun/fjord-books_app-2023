# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human) }
      format.json { render :show, status: :created, location: @comment }
    end
  end

  private

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
