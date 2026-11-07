cask "detect-it-easy" do
  arch arm: "arm64", intel: "x86_64"

  version "4.0.0"
  sha256 arm:   "b9c3f8b651d960a3b72e54a79a8c06a9ad0c6b1d7a29358823e840aa69aadcbc",
         intel: "9ae0383eecb2132f688d4abd1a8fcc95cf8910c7846ed85efc70ab8e7c5bb45e"

  url "https://github.com/horsicq/DIE-engine/releases/download/#{version}/die_#{version}_mac_#{arch}_qt6.dmg"
  name "Detect It Easy"
  desc "File identification and static inspection tool"
  homepage "https://github.com/horsicq/Detect-It-Easy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "die.app"
  binary "#{appdir}/die.app/Contents/MacOS/diec"
end
