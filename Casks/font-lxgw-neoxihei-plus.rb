cask "font-lxgw-neoxihei-plus" do
  version "1.304"
  sha256 "bd88d67c8c70d95cb12148fb7b7d6a1239562324ec87436a3806ea041f54ab82"

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
