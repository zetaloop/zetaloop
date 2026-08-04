cask "font-misans-tc" do
  version "1.002"
  sha256 "417831f033601f1738fefb2ce9158586d0143385a9dd0c4cfa985bcc16c7443b"

  url "https://hyperos.mi.com/font-download/MiSans_TC.zip"
  name "MiSans TC"
  desc "MiSans Traditional Chinese variable font"
  homepage "https://hyperos.mi.com/font/"

  livecheck do
    skip "No version information available"
  end

  font "MiSans TC/可变字体/MisansTC VF.ttf"
end
