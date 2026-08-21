cask "font-lxgw-neoxihei" do
  version "1.305"
  sha256 "893cfbec604768f03785ab4f369508de68c274273359a5cadee17e2852975d5c"

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
