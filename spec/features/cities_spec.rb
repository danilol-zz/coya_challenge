require "rails_helper"

describe "City info", type: :feature, vcr: true do
  context "accessing root path" do
    scenario "" do
      visit root_path
      expect(current_path).to eq "/"
      expect(page).to have_content("Berlin")
      expect(page).to have_content("Germany")
      expect(page).to have_content("18.51")
      expect(page).to have_content("EUR")
    end
  end

  context "accessing a city page" do
    let(:city) { "Tokyo" }

    scenario "" do
      visit city_info_path(city)
      expect(current_path).to eq "/Tokyo"
      expect(page).to have_content("Tokyo")
      expect(page).to have_content("Japan")
      expect(page).to have_content("22.05")
      expect(page).to have_content("JPY")
    end
  end
end
