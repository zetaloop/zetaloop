cask "font-iosevka-sgr-term-slab" do
  version "34.9.0"
  sha256 "4a8a88630cb46fa4b7f9ce90fdaf9d26fcfefc360ea5c58c7e51c4535b2d8e39"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-SGr-IosevkaTermSlab-#{version}.zip"
  name "SGr Iosevka Term Slab"
  desc "Terminal slab-serif monospace variant of Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SGr-IosevkaTermSlab.ttc"
end
