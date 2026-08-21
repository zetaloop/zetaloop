cask "font-lxgw-neozhisong" do
  version "1.067"
  sha256 "32b398f9c6278c4ed34f413077add2c2f3c84034d463af2b9cb98f12c4c2c6cd"

  url "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v#{version}/LXGWNeoZhiSong.ttf"
  name "LXGW Neo ZhiSong"
  name "霞鹜新致宋"
  desc "LXGW Neo ZhiSong Chinese serif font with local metrics variant"
  homepage "https://github.com/lxgw/LxgwNeoZhiSong"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on formula: "uv"

  font "LXGWNeoZhiSong.ttf"
  font "LXGWNeoZhiSongO.ttf"

  preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/uv",
                   args: ["run", "#{__dir__}/../scripts/transform-neozhisong.py", "#{staged_path}/LXGWNeoZhiSong.ttf"]
  end
end
