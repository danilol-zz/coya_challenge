class CitiesController < ApplicationController

  def index
    @report = WeatherReport.new(filtered_params).fetch
    @info   = CountryInfo.new(filtered_params).fetch
  end

  private

  def filtered_params
    params.permit(:city)
  end
end
