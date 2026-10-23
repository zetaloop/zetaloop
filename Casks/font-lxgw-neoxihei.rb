cask "font-lxgw-neoxihei" do
  version "1.306"
  sha256 "be689cc74a8a63e339361b6fd3cb46d7d499d5a4c659a022a07525b94c9728c8"

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
