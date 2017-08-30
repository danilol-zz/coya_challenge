class CoyaPresenter
  attr_accessor :report, :country_info

  def initialize(report, country_info)
    @report = report
    @country_info = country_info
  end

  def code
    [country_info.code, report.code].max
  end

  def success?
    country_info.success? && report.success?
  end

  def country
    country_info.name
  end

  def currency
    country_info.currencies.try(:first).try(:[], "code")
  end

  def city
    report.city
  end

  def temp
    report.try(:weather).try(:[], :temp)
  end

  def error_message
    country_info.message || report.message
  end

  def weather_icon_url
    "weather_icons/#{report.weather[:main].downcase}.svg" if report.weather
  end
end
