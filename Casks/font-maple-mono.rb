cask "font-maple-mono" do
  version "7.9"
  sha256 "b9e57677cc4ec069ce178bd965d66cd14bd26c12e37d89d786ff959339bf8c93"

  url "https://github.com/subframe7536/maple-font/releases/download/v#{version}/MapleMono-Variable.zip"
  name "Maple Mono"
  desc "Rounded monospace font with ligatures"
  homepage "https://font.subf.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "MapleMono-Italic[wght].ttf"
  font "MapleMono[wght].ttf"
end
