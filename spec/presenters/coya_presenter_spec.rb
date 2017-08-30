require 'rails_helper'

describe CoyaPresenter do
  subject(:presenter) { described_class.new(report, country_info)}

  context "when both objects have success response" do
    let(:report)        { double('WeatherReport', code: 200, success?: true, city: "Berlin", weather: {temp: 20}, message: nil) }
    let(:country_info)  { double('CountryInfo', code: 200, success?: true, name: "Germany", currencies: [ { "code" => "EUR" } ], message: nil) }

    it "builds the object with only attributes used by the view" do
      expect(subject.code).to eq(200)
      expect(subject.success?).to eq(true)
      expect(subject.city).to eq("Berlin")
      expect(subject.currency).to eq("EUR")
      expect(subject.country).to eq("Germany")
      expect(subject.temp).to eq(20)
      expect(subject.error_message).to eq(nil)
    end
  end

  context "when country_info service fails" do
    let(:report)        { double('WeatherReport', code: 200, success?: true, city: "Berlin", weather: {temp: 20}, message: nil) }
    let(:country_info)  { double('CountryInfo', code: 404, success?: false, name: nil, currencies: nil, message: "Not Found") }

    it "builds the object with only attributes used by the view" do
      expect(subject.code).to eq(404)
      expect(subject.success?).to eq(false)
      expect(subject.city).to eq("Berlin")
      expect(subject.currency).to eq(nil)
      expect(subject.country).to eq(nil)
      expect(subject.temp).to eq(20)
      expect(subject.error_message).to eq("Not Found")
    end
  end

  context "when weather_report service fails" do
    let(:report)        { double('WeatherReport', code: 404, success?: false, city: "Berlin", weather: nil, message: "Not Found") }
    let(:country_info)  { double('CountryInfo', code: 200, success?: true, name: "Germany", currencies: [ { "code" => "EUR" } ], message: nil) }

    it "builds the object with only attributes used by the view" do
      expect(subject.code).to eq(404)
      expect(subject.success?).to eq(false)
      expect(subject.city).to eq("Berlin")
      expect(subject.currency).to eq("EUR")
      expect(subject.country).to eq("Germany")
      expect(subject.temp).to eq(nil)
      expect(subject.error_message).to eq("Not Found")
    end
  end
end
