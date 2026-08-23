cask "font-iosevka-sgr-term-slab" do
  version "34.8.1"
  sha256 "2bb9a934e46d09b2d7083e6a290a16d32e78d3a359836cc32a9c944485c7e38f"

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
