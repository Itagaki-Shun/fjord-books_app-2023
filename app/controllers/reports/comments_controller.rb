# frozen_string_literal: true

class Reports::CommentsController < ApplicationController
  include Commentable

  before_action :set_commentable

  private

  def set_commentable
    @commentable = @report = Report.find(params[:report_id])
  end
end
