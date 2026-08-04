cask "font-lxgw-neoxihei" do
  version "1.304"
  sha256 "5965dd992290861c6d62285098dc5ca7f6c669930765fd11d5d0fd4912d816e7"

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
