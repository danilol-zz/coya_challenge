require "rails_helper"

describe CountryInfo do
  let(:country_info) { described_class.new(options) }

  context ".fetch", vcr: { record: :once } do
    subject { country_info.response }

    context "by capital" do
      context "when the capital exists" do
        let(:options) { { city: "Berlin" } }

        before { country_info.fetch }

        it "returns the country info" do
          expect(subject).to be_a OpenStruct
          expect(subject.success?).to be true
          expect(subject.code).to    eq 200
          expect(subject.name).to    eq "Germany"
          expect(subject.capital).to eq "Berlin"
          expect(subject.currencies.first).to eq ({ "code"=>"EUR", "name"=>"Euro", "symbol"=>"€" })
        end
      end

      context "when the capital was not found" do
        let(:options) { { city: "12312212121" } }

        before { country_info.fetch }

        it "returns the city weather" do
          expect(subject).to be_a OpenStruct
          expect(subject.success?).to be false
          expect(subject.code).to     eq 404
          expect(subject.message).to  eq "Not Found"
        end
      end
    end

    context "when request reaches timeout" do
      let(:response) { OpenStruct.new(code: 408, message: "Request Timeout: execution expired", success?: false) }
      let(:options) { { city: "Berlin" } }

      before do
        allow(country_info).to receive(:handle_timeouts).and_return(response)
        country_info.fetch
      end

      it "returns an Error" do
        expect(subject).to be_a OpenStruct
        expect(subject.success?).to be false
        expect(subject.code).to     eq 408
        expect(subject.message).to  eq "Request Timeout: execution expired"
      end
    end
  end
end
