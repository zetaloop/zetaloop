cask "font-victor-mono" do
  version "1.5.6"
  sha256 "eab377ad3bcc7a202697c024ebb8c8728f99789c4f093d358f3d202052cc9496"

  url "https://raw.githubusercontent.com/rubjo/victor-mono/v#{version}/public/VictorMonoAll.zip"
  name "Victor Mono"
  desc "Monospaced font with cursive italics and programming ligatures"
  homepage "https://rubjo.github.io/victor-mono/"

  livecheck do
    url "https://github.com/rubjo/victor-mono"
    strategy :github_latest
  end

  font "TTF/VictorMono-Bold.ttf"
  font "TTF/VictorMono-BoldItalic.ttf"
  font "TTF/VictorMono-BoldOblique.ttf"
  font "TTF/VictorMono-ExtraLight.ttf"
  font "TTF/VictorMono-ExtraLightItalic.ttf"
  font "TTF/VictorMono-ExtraLightOblique.ttf"
  font "TTF/VictorMono-Italic.ttf"
  font "TTF/VictorMono-Light.ttf"
  font "TTF/VictorMono-LightItalic.ttf"
  font "TTF/VictorMono-LightOblique.ttf"
  font "TTF/VictorMono-Medium.ttf"
  font "TTF/VictorMono-MediumItalic.ttf"
  font "TTF/VictorMono-MediumOblique.ttf"
  font "TTF/VictorMono-Oblique.ttf"
  font "TTF/VictorMono-Regular.ttf"
  font "TTF/VictorMono-SemiBold.ttf"
  font "TTF/VictorMono-SemiBoldItalic.ttf"
  font "TTF/VictorMono-SemiBoldOblique.ttf"
  font "TTF/VictorMono-Thin.ttf"
  font "TTF/VictorMono-ThinItalic.ttf"
  font "TTF/VictorMono-ThinOblique.ttf"
end
