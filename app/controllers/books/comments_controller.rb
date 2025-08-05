# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  include Commentable

  before_action :set_commentable

  private

  def set_commentable
    @commentable = @book = Book.find(params[:book_id])
  end

  def on_save_error
    @book = @commentable
    render 'books/show', status: :unprocessable_entity
  end
end
