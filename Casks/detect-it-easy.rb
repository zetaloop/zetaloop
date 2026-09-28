cask "detect-it-easy" do
  version "3.21"
  sha256 "9b6411f4976593988fbcdc8d1ed2fd8123996e4b9f4a43df6a841460c229794b"

  url "https://github.com/horsicq/DIE-engine/releases/download/#{version}/die_mac_qt6_#{version}_arm64.pkg"
  name "Detect It Easy"
  desc "File identification and static inspection tool"
  homepage "https://github.com/horsicq/Detect-It-Easy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  pkg "die_mac_qt6_#{version}_arm64.pkg"
  binary "/Applications/DiE.app/Contents/MacOS/diec"

  uninstall quit:    "com.yourcompany.DiE",
            pkgutil: "ntinfo.die"
end
