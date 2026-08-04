cask "font-iosevka-sgr-slab" do
  version "34.8.0"
  sha256 "ba91053fd83e882de92dc5af1c90c0e2b3aed5cc3b3fb83f5c0e5b0e951c9376"

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
