cask "font-lxgw-marker-gothic" do
  version "1.003"
  sha256 "858f40c1b0a4c62a2949a13a071bfbc0075a096ab84b85a3f783688547f57444"

  url "https://github.com/lxgw/LxgwMarkerGothic/releases/download/v#{version}/LxgwMarkerGothic-v#{version}.zip"
  name "LXGW Marker Gothic"
  desc "LXGW Marker Gothic Chinese display font"
  homepage "https://github.com/lxgw/LxgwMarkerGothic"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LxgwMarkerGothic-v#{version}/fonts/ttf/LXGWMarkerGothic-Regular.ttf"
end
