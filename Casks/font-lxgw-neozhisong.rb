cask "font-lxgw-neozhisong" do
  version "1.070"
  sha256 "c42000b59caffe8ccfcd1c90aa2841dcafa866cf24769cc1b10c3708c671f207"

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

  preflight_steps do
    run "bin/uv", base:           :homebrew_prefix,
                  args:           ["run", "https://raw.githubusercontent.com/zetaloop/zetaloop/main/scripts/transform-neozhisong.py",
                                   "{{staged_path}}/LXGWNeoZhiSong.ttf"],
                  network_access: true
  end
end
