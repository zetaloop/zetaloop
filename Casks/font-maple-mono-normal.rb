cask "font-maple-mono-normal" do
  version "7.9"
  sha256 "d6e77dcce1c5d68636392fd4d77a422e74602c31f465de63d5e222301fc5f637"

  url "https://github.com/subframe7536/maple-font/releases/download/v#{version}/MapleMonoNormal-Variable.zip"
  name "Maple Mono Normal"
  desc "Conventional-glyph rounded monospace font with ligatures"
  homepage "https://font.subf.dev/"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormal-Italic[wght].ttf"
  font "MapleMonoNormal[wght].ttf"
end
