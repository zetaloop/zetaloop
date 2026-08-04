cask "font-misans-l3" do
  version "1.000"
  sha256 "467fe0171ec9ea21d925aba9c032b1a775a3e756c458f075e7a2ee57568b0c79"

  url "https://hyperos.mi.com/font-download/MiSans_L3.zip"
  name "MiSans L3"
  desc "MiSans GB 18030-2022 Level 3 rare-character font"
  homepage "https://hyperos.mi.com/font/rare-word/"

  livecheck do
    skip "No version information available"
  end

  font "MiSans L3/MiSans L3.ttf"
end
