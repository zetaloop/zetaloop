cask "font-iosevka-sgr-slab" do
  version "34.8.1"
  sha256 "ae5ff9d1c28c9739c3aa1f51929c11e93b6f8c0ce43136674e298c231358419a"

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
