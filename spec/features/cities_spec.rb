require "rails_helper"

describe "City info", type: :feature do
  context "accessing root path" do
    scenario "" do
      visit root_path
      expect(current_path).to eq "/"
    end
  end

  context "accessing a city page" do
    let(:city) { "Berlin" }

    scenario "" do
      visit city_info_path(city)
      expect(current_path).to eq "/Berlin"
    end
  end
end
