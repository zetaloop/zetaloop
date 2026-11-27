cask "font-iosevka-sgr-term-slab" do
  version "34.9.2"
  sha256 "febc775dbea630e41139726041e3dcf97ad8dc63a95df7354471e28d50dd0dac"

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
