cask "font-lxgw-bright-code" do
  version "26.10.22"
  sha256 "bca15abc861b5763a0338b83ed85675384e035df2b64e314971a3bc44e45ab61"

  url "https://github.com/lxgw/LxgwBright-Code/releases/download/#{version}/LxgwBrightCode.7z"
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
