cask "font-maple-mono-normal-nf-cn" do
  version "7.9"
  sha256 "24aeb14ed756d78b112e6692ea02c669e16afaa0f01e7bfdbb37d2e63fa45fa7"

  url "https://github.com/subframe7536/maple-font/releases/download/v#{version}/MapleMonoNormal-NF-CN.zip"
  name "Maple Mono Normal NF CN"
  desc "Conventional-glyph rounded monospace font with Nerd Font icons and Chinese glyphs"
  homepage "https://font.subf.dev/"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormal-NF-CN-Bold.ttf"
  font "MapleMonoNormal-NF-CN-BoldItalic.ttf"
  font "MapleMonoNormal-NF-CN-ExtraBold.ttf"
  font "MapleMonoNormal-NF-CN-ExtraBoldItalic.ttf"
  font "MapleMonoNormal-NF-CN-ExtraLight.ttf"
  font "MapleMonoNormal-NF-CN-ExtraLightItalic.ttf"
  font "MapleMonoNormal-NF-CN-Italic.ttf"
  font "MapleMonoNormal-NF-CN-Light.ttf"
  font "MapleMonoNormal-NF-CN-LightItalic.ttf"
  font "MapleMonoNormal-NF-CN-Medium.ttf"
  font "MapleMonoNormal-NF-CN-MediumItalic.ttf"
  font "MapleMonoNormal-NF-CN-Regular.ttf"
  font "MapleMonoNormal-NF-CN-SemiBold.ttf"
  font "MapleMonoNormal-NF-CN-SemiBoldItalic.ttf"
  font "MapleMonoNormal-NF-CN-Thin.ttf"
  font "MapleMonoNormal-NF-CN-ThinItalic.ttf"
end
