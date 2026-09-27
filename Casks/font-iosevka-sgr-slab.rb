cask "font-iosevka-sgr-slab" do
  version "34.9.0"
  sha256 "48196aa18c7be796b35589ce76c945aafe3f8085b4572cc01fb3d1cedc10d530"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-SGr-IosevkaSlab-#{version}.zip"
  name "SGr Iosevka Slab"
  desc "Slab-serif monospace variant of Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SGr-IosevkaSlab.ttc"
end
