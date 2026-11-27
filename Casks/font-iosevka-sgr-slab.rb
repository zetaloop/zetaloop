cask "font-iosevka-sgr-slab" do
  version "34.9.2"
  sha256 "e0db21257ba6a5de0dc89e3954a608d61424f4a6adb3b9b8e33fe3c922d81ae4"

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
