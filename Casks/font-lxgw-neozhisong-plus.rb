cask "font-lxgw-neozhisong-plus" do
  version "1.067"
  sha256 "639595c65001872d0da16dacaeb7de3ba396c64c37b70a16feb1536091bb6c1f"

  url "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v#{version}/LXGWNeoZhiSongPlus.ttf"
  name "LXGW Neo ZhiSong Plus"
  name "霞鹜新致宋 Plus"
  desc "Extended LXGW Neo ZhiSong Chinese serif font with local metrics variant"
  homepage "https://github.com/lxgw/LxgwNeoZhiSong"

  livecheck do
    cask "font-lxgw-neozhisong"
  end

  depends_on formula: "uv"

  font "LXGWNeoZhiSongPlus.ttf"
  font "LXGWNeoZhiSongPlusO.ttf"

  preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/uv",
                   args: ["run", "#{__dir__}/../scripts/transform-neozhisong.py",
                          "#{staged_path}/LXGWNeoZhiSongPlus.ttf"]
  end
end
