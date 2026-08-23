cask "font-iosevka-sgr-term" do
  version "34.8.1"
  sha256 "82104935dd6ca700b4f1ef713fdc0daa6c667065228d1c7a20e593d93b48b232"

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
