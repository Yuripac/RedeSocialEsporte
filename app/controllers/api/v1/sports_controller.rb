
class Api::V1::SportsController < Api::V1::ApiController

  # GET api/v1/sports
  def index
    sports = Sport.all

    success(json: sports)
  end

end
