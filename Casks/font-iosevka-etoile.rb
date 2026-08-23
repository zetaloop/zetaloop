cask "font-iosevka-etoile" do
  version "34.8.1"
  sha256 "50d3c91ee71c982f7c34e80da21e1d00e7a5339c8b5f122faebf5d5e271c4e2f"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-IosevkaEtoile-#{version}.zip"
  name "Iosevka Etoile"
  desc "Slab-serif quasi-proportional companion to Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaEtoile.ttc"
end
