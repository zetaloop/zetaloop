cask "font-iosevka-etoile" do
  version "34.9.2"
  sha256 "647654c655d74907e72e4caa54b2debf706d7abdf985afda5405b7892d70a1c4"

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
