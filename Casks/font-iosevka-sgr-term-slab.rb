cask "font-iosevka-sgr-term-slab" do
  version "34.9.1"
  sha256 "9d1a93b0af0456220de583687c16ff3b9e8498928e48bda39e383578d137e044"

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
