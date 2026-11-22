cask "overcast" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.1.0"
  sha256 arm:   "d0f53ccffed045e9e0b85d67a1fa0bf6bc7355bc2b4d36e9d36504e8031b8344",
         intel: "87173270430c272824df59b7cd0c5d89a7faf07ae28eee287f1aa48cb664f858"

  url "https://github.com/zetaloop/overcast/releases/download/v#{version}/overcast-#{arch}-apple-darwin"
  name "Overcast"
  desc "Proxy orchestration across Xray, sing-box, and Mihomo"
  homepage "https://github.com/zetaloop/overcast"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos
  container type: :naked

  binary "overcast-#{arch}-apple-darwin", target: "overcast"

  preflight_steps do
    write_file "overcast-{{arch}}-apple-darwin.channel",
               '{"name":"Homebrew","executable":"{{HOMEBREW_PREFIX}}/bin/overcast"}'
  end

  postflight_steps do
    if_path_exists "overcast.plist", base: :temp do
      run "/bin/sh", args: ["-eu", "-c", <<~SH, "overcast", "{{temp}}", "{{HOMEBREW_PREFIX}}/bin/overcast"],
        plist=/Library/LaunchDaemons/build.loop.overcast.plist
        test ! -e "$plist"
        dir=$(/usr/bin/mktemp -d /Library/LaunchDaemons/.overcast.XXXXXXXX)
        trap '/bin/rm -f "$dir/original"; /bin/rmdir "$dir"' EXIT
        /bin/mv "$1/overcast.plist" "$dir/original"
        test ! -L "$dir/original" && test -f "$dir/original" || exit 1
        case "$(/usr/bin/stat -f '%u:%Lp' "$dir/original")" in 0:644|0:600|0:640) ;; *) exit 1 ;; esac
        test "$(/usr/bin/plutil -extract Label raw -o - "$dir/original")" = build.loop.overcast
        test "$(/usr/bin/plutil -extract ProgramArguments.0 raw -o - "$dir/original")" = "$2"
        /bin/ln "$dir/original" "$plist"
        if test -d "$1/loaded"; then /bin/launchctl bootstrap system "$plist"; fi
      SH
                     sudo: true
    end
  end

  uninstall_preflight_steps do
    if_path_exists "/Library/LaunchDaemons/build.loop.overcast.plist" do
      run "/bin/sh", args: ["-eu", "-c", <<~SH, "overcast", "{{temp}}", "{{HOMEBREW_PREFIX}}/bin/overcast"],
        plist=/Library/LaunchDaemons/build.loop.overcast.plist
        program=$(/usr/bin/plutil -extract ProgramArguments.0 raw -o - "$plist")
        test "$program" = "$2" || exit 0
        if /bin/launchctl print system/build.loop.overcast >/dev/null; then
          /bin/launchctl bootout --wait system/build.loop.overcast
          /bin/mkdir "$1/loaded"
        else
          status=$?
          test "$status" -eq 113 || exit "$status"
        fi
        /bin/mv -h "$plist" "$1/overcast.plist"
      SH
                     sudo: true
    end
  end
end
