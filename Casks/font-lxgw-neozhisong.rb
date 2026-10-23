cask "font-lxgw-neozhisong" do
  version "1.068"
  sha256 "ae480d59294b6a318173e3581a58d1a385cf3ad4467a6590b05b3747ea292a3a"

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
