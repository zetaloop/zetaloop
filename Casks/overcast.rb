cask "overcast" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.0"
  sha256 arm:   "7ab24cb5f19d854eb9c63e350884ef6b865feacd87fb1572521ac8857f3a1db1",
         intel: "9a0a4925d6cfc889be8b175cf318bd85aecff09bbec8dbaf3d93e842f38fb78c"

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
        trap '/bin/rmdir "$dir" 2>/dev/null || printf "Service definition retained at %s/original\\n" "$dir" >&2' EXIT
        /bin/mv "$1/overcast.plist" "$dir/original"
        test ! -L "$dir/original" && test -f "$dir/original" || exit 1
        case "$(/usr/bin/stat -f '%u:%Lp' "$dir/original")" in 0:644|0:600|0:640) ;; *) exit 1 ;; esac
        test "$(/usr/bin/plutil -extract Label raw -o - "$dir/original")" = build.loop.overcast
        test "$(/usr/bin/plutil -extract ProgramArguments.0 raw -o - "$dir/original")" = "$2"
        /bin/mv -n "$dir/original" "$plist"
        test ! -e "$dir/original"
        if test -d "$1/loaded"; then /bin/launchctl bootstrap system "$plist"; fi
      SH
                     sudo: true, writable_paths: ["/Library/LaunchDaemons"]
    end
  end

  uninstall_preflight_steps do
    if_path_exists "/Library/LaunchDaemons/build.loop.overcast.plist" do
      run "/bin/sh", args: ["-eu", "-c", <<~SH, "overcast", "{{temp}}", "{{HOMEBREW_PREFIX}}/bin/overcast"],
        plist=/Library/LaunchDaemons/build.loop.overcast.plist
        program=$(/usr/bin/plutil -extract ProgramArguments.0 raw -o - "$plist")
        test "$program" = "$2" || exit 0
        if job=$(/bin/launchctl print system/build.loop.overcast); then
          /bin/launchctl bootout --wait system/build.loop.overcast
          if printf '%s\\n' "$job" | /usr/bin/grep -qx '[[:blank:]]state = running'; then /bin/mkdir "$1/loaded"; fi
        else
          status=$?
          test "$status" -eq 113 || exit "$status"
        fi
        /bin/mv -h "$plist" "$1/overcast.plist"
      SH
                     sudo: true, writable_paths: ["/Library/LaunchDaemons"]
    end
  end
end
