cask "font-iosevka-sgr-term" do
  version "34.9.1"
  sha256 "bb4036bf968571653c02f6c4662b1970485295ad98d746c741734a32bb815c9c"

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
