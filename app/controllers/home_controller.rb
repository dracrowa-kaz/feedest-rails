class HomeController < ApplicationController
  skip_before_action :authenticate_user_from_token!, only: [:index]
  def index
  end
end
