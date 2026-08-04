cask "font-lxgw-neozhisong-plus" do
  version "1.066"
  sha256 "279c973effc2811a827713ffa12706d556cab10b5067c0728400bf9e464f7008"

  url "https://github.com/lxgw/LxgwNeoZhiSong/releases/download/v#{version}/LXGWNeoZhiSongPlus.ttf"
  name "LXGW Neo ZhiSong Plus"
  name "霞鹜新致宋 Plus"
  desc "Extended LXGW Neo ZhiSong Chinese serif font with local metrics variant"
  homepage "https://github.com/lxgw/LxgwNeoZhiSong"

  livecheck do
    cask "font-lxgw-neozhisong"
  end

  depends_on formula: "uv"

  preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/uv",
                   args: ["run", "#{__dir__}/../scripts/transform-neozhisong.py", "#{staged_path}/LXGWNeoZhiSongPlus.ttf"]
  end

  font "LXGWNeoZhiSongPlus.ttf"
  font "LXGWNeoZhiSongPlusO.ttf"
end
