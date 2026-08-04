cask "font-misans" do
  version "4.003"
  sha256 "b6aa1fc827035922612df8edf36e5609bca1c5441e25cd57572204569b7b81d9"

  url "https://hyperos.mi.com/font-download/MiSans.zip"
  name "MiSans"
  desc "MiSans variable font"
  homepage "https://hyperos.mi.com/font/"

  livecheck do
    skip "No version information available"
  end

  font "MiSans/可变字体/MiSansVF.ttf"
end
