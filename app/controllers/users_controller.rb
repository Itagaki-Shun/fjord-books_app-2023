# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id).order(:id).page(params[:page])
  end

  def mypage
    @user = current_user
    render :show
  end

  def show
    @user = User.find(params[:id])
  end
end
