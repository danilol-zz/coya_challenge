require "rails_helper"

describe WeatherReport do
  let(:weather_report) { described_class.new(options) }

  context ".fetch", vcr: { record: :once } do
    subject { weather_report.response }

    context "by city" do
      context "when the city exists" do
        let(:options) { { city: "Berlin" } }

        before { weather_report.fetch }

        it "returns the city weather" do
          expect(subject).to be_a OpenStruct
          expect(subject.success?).to be true
          expect(subject.code).to           eq 200
          expect(subject.city).to           eq "Berlin"
          expect(subject.weather[:main]).to eq "Clouds"
        end
      end

      context "when the city doesn't exist" do
        let(:options) { { city: "12312212121" } }

        before { weather_report.fetch }

        it "returns the city weather" do
          expect(subject).to be_a OpenStruct
          expect(subject.success?).to be false
          expect(subject.code).to     eq 404
          expect(subject.message).to  eq "city not found"
        end
      end
    end

    context "when request reaches timeout" do
      let(:response) { OpenStruct.new(code: 408, message: "Request Timeout: execution expired", success?: false) }
      let(:options) { { city: "Berlin" } }

      before do
        allow(weather_report).to receive(:handle_timeouts).and_return(response)
        weather_report.fetch
      end

      it "returns Random weather" do
        expect(subject).to be_a OpenStruct
        expect(subject.success?).to be false
        expect(subject.code).to     eq 408
        expect(subject.message).to  eq "Request Timeout: execution expired"
      end
    end
  end
end
