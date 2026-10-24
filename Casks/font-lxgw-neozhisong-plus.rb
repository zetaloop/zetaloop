cask "font-lxgw-neozhisong-plus" do
  version "1.070"
  sha256 "3011dac1d68f7df22c9ae4a91beed323dd7266c0b29da9f1c540242522b68f0c"

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

  preflight_steps do
    run "bin/uv", base:           :homebrew_prefix,
                  args:           ["run", "https://raw.githubusercontent.com/zetaloop/zetaloop/main/scripts/transform-neozhisong.py",
                                   "{{staged_path}}/LXGWNeoZhiSongPlus.ttf"],
                  network_access: true
  end
end
