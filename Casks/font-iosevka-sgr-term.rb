cask "font-iosevka-sgr-term" do
  version "34.9.2"
  sha256 "e79ae367e9938460e31852b66bead8caa207fb91a6755b21537380d468a1720f"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-SGr-IosevkaTerm-#{version}.zip"
  name "SGr Iosevka Term"
  desc "Terminal monospace variant of Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SGr-IosevkaTerm.ttc"
end
