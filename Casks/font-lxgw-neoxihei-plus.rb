cask "font-lxgw-neoxihei-plus" do
  version "1.308"
  sha256 "4dc82a80d297c0a679ff69a9d746246dd76472a865b2b2b208e5efc14f2068c1"

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
