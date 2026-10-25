cask "font-iosevka-sgr-slab" do
  version "34.9.1"
  sha256 "acae632c055732255d597cf8f4248c5b30bc0f0d345405eec8bcac448f0435cd"

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
