cask "font-lxgw-bright" do
  version "26.10.22"
  sha256 "cbd632f0c0f08f111329cbb0fc63cdec28be89cced3533b2c00f05e8eaf237fb"

  url "https://github.com/lxgw/LxgwBright/releases/download/#{version}/LXGWBright.7z"
  name "LXGW Bright"
  desc "LXGW Bright CJK sans-serif font family"
  homepage "https://github.com/lxgw/LxgwBright"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWBright/LXGWBright-Italic.ttf"
  font "LXGWBright/LXGWBright-Light.ttf"
  font "LXGWBright/LXGWBright-LightItalic.ttf"
  font "LXGWBright/LXGWBright-Medium.ttf"
  font "LXGWBright/LXGWBright-MediumItalic.ttf"
  font "LXGWBright/LXGWBright-Regular.ttf"
end
