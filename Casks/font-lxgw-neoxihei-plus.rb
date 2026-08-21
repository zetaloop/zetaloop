cask "font-lxgw-neoxihei-plus" do
  version "1.305"
  sha256 "68261add407bd795c040fe662b7e21e5a766acc9a534c393473f8a972c5ed224"

  url "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v#{version}/LXGWNeoXiHeiPlus.ttf"
  name "LXGW Neo XiHei Plus"
  name "霞鹜新晰黑 Plus"
  desc "Extended LXGW Neo XiHei Chinese sans-serif font"
  homepage "https://github.com/lxgw/LxgwNeoXiHei"

  livecheck do
    cask "font-lxgw-neoxihei"
  end

  font "LXGWNeoXiHeiPlus.ttf"
end
