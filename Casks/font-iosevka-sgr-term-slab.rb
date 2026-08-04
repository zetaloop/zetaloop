cask "font-iosevka-sgr-term-slab" do
  version "34.8.0"
  sha256 "069a2a2e97531ca26e04d54efbcc0aea13e1f0e78efe913d7bd23fecba8fab26"

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
