cask "font-lxgw-neoxihei" do
  version "1.309"
  sha256 "2e938517d1bb2d23c452829bac6c2830a4577d9eebbad22445c5c4191eb4308f"

  url "https://github.com/lxgw/LxgwNeoXiHei/releases/download/v#{version}/LXGWNeoXiHei.ttf"
  name "LXGW Neo XiHei"
  name "霞鹜新晰黑"
  desc "LXGW Neo XiHei Chinese sans-serif font"
  homepage "https://github.com/lxgw/LxgwNeoXiHei"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWNeoXiHei.ttf"
end
