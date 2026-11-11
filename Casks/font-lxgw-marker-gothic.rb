cask "font-lxgw-marker-gothic" do
  version "1.012"
  sha256 "a1cdbc3471db7390f2358ce18db173aa21906f67652434bf9beae61911201da1"

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
