cask "font-lxgw-marker-gothic" do
  version "1.011"
  sha256 "52f09b47abef9292c7eb547bb88ba971e4014095dc672bdc99d68cc58bb5891c"

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
