cask "font-lxgw-bright-code" do
  version "2.922"
  sha256 "bfefc5f32132bf284a039011deabea40ba350eaab0d8629e1aa160232897d3dd"

  url "https://github.com/lxgw/LxgwBright-Code/releases/download/v#{version}/LxgwBrightCode.7z"
  name "LXGW Bright Code"
  desc "Monospace programming variant of LXGW Bright"
  homepage "https://github.com/lxgw/LxgwBright-Code"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LxgwBrightCode/LXGWBrightCode-ExtraLight.ttf"
  font "LxgwBrightCode/LXGWBrightCode-ExtraLightItalic.ttf"
  font "LxgwBrightCode/LXGWBrightCode-Italic.ttf"
  font "LxgwBrightCode/LXGWBrightCode-Light.ttf"
  font "LxgwBrightCode/LXGWBrightCode-LightItalic.ttf"
  font "LxgwBrightCode/LXGWBrightCode-Regular.ttf"
end
