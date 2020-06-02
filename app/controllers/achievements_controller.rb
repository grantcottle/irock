# frozen_string_literal: true

class AchievementsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :owners_only, only: %i[edit update destroy]

  def index
    @achievements = Achievement.public_access
  end

  def new
    @achievement = Achievement.new
  end

  def create
    @achievement = Achievement.new(achievement_params)
    @achievement.user = current_user
    if @achievement.save
      UserMailer.achievement_created(current_user.email, @achievement.id).deliver_now
      redirect_to achievement_url(@achievement), notice: 'Achievement has been created'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @achievement.update_attributes(achievement_params)
      redirect_to achievement_path(@achievement)
    else
      render :edit
    end
  end

  def show
    @achievement = Achievement.find(params[:id])
  end

  def destroy
    @achievement.destroy
    redirect_to achievements_path
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :featured)
  end

  def owners_only
    @achievement = Achievement.find(params[:id])
    redirect_to achievements_path if current_user != @achievement.user
  end
end
