cask "font-space-grotesk" do
  version "2.0.0"
  sha256 "acad6de1fc93436f5c0f1f4137751ef04f1aea3063e7036535970ffcfbd79f72"

  url "https://raw.githubusercontent.com/floriankarsten/space-grotesk/#{version}/fonts/ttf/SpaceGrotesk%5Bwght%5D.ttf"
  name "Space Grotesk"
  desc "Proportional sans-serif variable font based on Space Mono"
  homepage "https://github.com/floriankarsten/space-grotesk"

  livecheck do
    url "https://github.com/floriankarsten/space-grotesk"
    strategy :github_latest
  end

  font "SpaceGrotesk[wght].ttf"
end
