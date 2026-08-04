cask "font-lxgw-neozhisong" do
  version "1.066"
  sha256 "95936a086ff7ad8e8b30288dec0e20e817976fa1275d8f11a85b1e6144c8d017"

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

  preflight do
    system_command "#{HOMEBREW_PREFIX}/bin/uv",
                   args: ["run", "#{__dir__}/../scripts/transform-neozhisong.py", "#{staged_path}/LXGWNeoZhiSong.ttf"]
  end

  font "LXGWNeoZhiSong.ttf"
  font "LXGWNeoZhiSongO.ttf"
end
