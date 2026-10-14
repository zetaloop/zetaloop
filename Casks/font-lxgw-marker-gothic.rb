cask "font-lxgw-marker-gothic" do
  version "1.004"
  sha256 "4a30c82200664d5366ed8ef822ee2085ad16c767862396b96b8924fd94297aa6"

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
