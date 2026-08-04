cask "font-lxgw-bright" do
  version "5.528"
  sha256 "a476ba9620dce0fbba7522fe578ed5cc7ba14518363612af583fe07ea33973ea"

  url "https://github.com/lxgw/LxgwBright/releases/download/v#{version}/LXGWBright.7z"
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
