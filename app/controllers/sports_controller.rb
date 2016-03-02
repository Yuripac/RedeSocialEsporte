class SportsController < InheritedResources::Base

  private

    def sport_params
      params.require(:sport).permit(:name)
    end
end

