cask "font-iosevka-sgr" do
  version "34.9.2"
  sha256 "4f5eaf3a1bdfa4fe49debb41ba754cb17a302846b43ba27ec118963cf41b1460"

  url "https://github.com/be5invis/Iosevka/releases/download/v#{version}/SuperTTC-SGr-Iosevka-#{version}.zip"
  name "SGr Iosevka"
  desc "Curly-braced monospace variant of Iosevka"
  homepage "https://github.com/be5invis/Iosevka/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SGr-Iosevka.ttc"
end
