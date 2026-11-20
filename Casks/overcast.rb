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

  executable = cask.config.binarydir/"overcast"
  plist = "/Library/LaunchDaemons/build.loop.overcast.plist"
  service = "system/build.loop.overcast"
  binary "overcast-#{arch}-apple-darwin", target: "overcast"

  preflight do
    (staged_path/"overcast-#{arch}-apple-darwin.channel").write(JSON.generate(name: "Homebrew", executable: executable.to_s))
  end

  uninstall_preflight do
    next unless File.exist?(plist)

    program = system_command "/usr/bin/plutil", args: ["-extract", "ProgramArguments.0", "raw", "-o", "-", plist]
    next unless program.stdout.chomp == executable.to_s

    definition = system_command "/usr/bin/plutil", args: ["-convert", "xml1", "-o", "-", plist]
    status = system_command "/bin/launchctl", args: ["print", service], must_succeed: false, print_stderr: false
    if status.success?
      system_command "/bin/launchctl", args: ["bootout", "--wait", service], sudo: true
    elsif status.exit_status != 113
      raise status.stderr
    end
    system_command "/bin/rm", args: [plist], sudo: true
    # Homebrew upgrades run the old uninstall and new install in the same process.
    Thread.current[:overcast_launchd] = [definition.stdout, status.success?]
  end

  postflight do
    next unless (previous = Thread.current[:overcast_launchd])

    definition, loaded = previous
    system_command "/usr/bin/plutil", args: ["-convert", "binary1", "-o", plist, "-"], input: definition, sudo: true
    system_command "/bin/launchctl", args: ["bootstrap", "system", plist], sudo: true if loaded
    Thread.current[:overcast_launchd] = nil
  end
end
