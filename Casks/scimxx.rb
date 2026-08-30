cask "scimxx" do
  version "0.1.0"
  sha256 "e2a9f53196f42d89fb9e74d9e05edefc18e61588c0b9f4da8c6f18e248448645"

  url "https://github.com/zetaloop/SCIMxx/releases/download/v#{version}/scimxx-v#{version}-macos-arm64e.tar.gz"
  name "SCIMxx"
  desc "Apple Pinyin enhancements for macOS 26"
  homepage "https://github.com/zetaloop/SCIMxx"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  binary "scimxx"

  caveats <<~EOS
    Run `scimxx install` after installing or upgrading SCIMxx.
    Run `scimxx uninstall` before uninstalling SCIMxx.
  EOS
end
