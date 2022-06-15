class AwardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @awards = Award.where(user_id: params[:user_id])
  end
end
