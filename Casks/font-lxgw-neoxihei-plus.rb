cask "font-lxgw-neoxihei-plus" do
  version "1.306"
  sha256 "c26a0f815174313271fdf448d43eaa49c92115eedfb87f50d9e0bf39131e53f4"

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
