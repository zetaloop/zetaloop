cask "font-varela-round" do
  version "1866b1b967b78211927c48c9835099c33fb85b3b"
  sha256 "e1e47eb66dbc2ddc106661338e712d9176c9e83c669a82fde155324823d03aa2"

  url "https://raw.githubusercontent.com/google/fonts/#{version}/ofl/varelaround/VarelaRound-Regular.ttf",
      verified: "raw.githubusercontent.com/google/fonts/"
  name "Varela Round"
  desc "Rounded sans-serif font for display and small sizes"
  homepage "https://fonts.google.com/specimen/Varela+Round"

  livecheck do
    url "https://api.github.com/repos/google/fonts/commits?path=ofl%2Fvarelaround%2FVarelaRound-Regular.ttf&per_page=1"
    strategy :json do |json|
      json.first&.dig("sha")
    end
  end

  font "VarelaRound-Regular.ttf"
end
