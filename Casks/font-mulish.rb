cask "font-mulish" do
  version "3.603"
  sha256 :no_check

  url "https://github.com/google/fonts.git",
      revision: "73086f05f20695bb8ea7e607781dc6ffe316fdbc",
      only_path: "ofl/mulish"
  name "Mulish"
  desc "Minimalist sans-serif variable font"
  homepage "https://fonts.google.com/specimen/Mulish"

  livecheck do
    skip "No version information available"
  end

  font "Mulish-Italic[wght].ttf"
  font "Mulish[wght].ttf"
end
