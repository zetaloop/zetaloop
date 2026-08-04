cask "font-mulish" do
  version "73086f05f20695bb8ea7e607781dc6ffe316fdbc"
  sha256 :no_check

  url "https://github.com/google/fonts.git",
      revision: "#{version}",
      only_path: "ofl/mulish"
  name "Mulish"
  desc "Minimalist sans-serif variable font"
  homepage "https://fonts.google.com/specimen/Mulish"

  livecheck do
    url "https://api.github.com/repos/google/fonts/commits?path=ofl%2Fmulish%2FMulish%5Bwght%5D.ttf&per_page=1"
    strategy :json do |json|
      json.first&.dig("sha")
    end
  end

  font "Mulish-Italic[wght].ttf"
  font "Mulish[wght].ttf"
end
