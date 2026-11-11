cask "font-lxgw-neoxihei-plus" do
  version "1.309"
  sha256 "868d537bbe7ea83a35a249fca829729ead9337828e0c4709f29be2277c117243"

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
