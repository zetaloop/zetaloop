cask "ilspy" do
  version "11.1.0.9782"
  sha256 "f908866dcedea6a3edb62a5cee9c3a91fe4564156b8284bab030aaa373342337"

  url "https://github.com/icsharpcode/ILSpy/releases/download/v#{version.major_minor}/ILSpy_macos-arm64_#{version}.zip"
  name "ILSpy"
  desc ".NET assembly browser and decompiler"
  homepage "https://github.com/icsharpcode/ILSpy"

  livecheck do
    url "https://api.github.com/repos/icsharpcode/ILSpy/releases/latest"
    regex(/ILSpy_macos-arm64_(\d+(?:\.\d+)+)\.zip/i)
  end

  depends_on arch: :arm64
  depends_on :macos

  app "ILSpy.app"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/ILSpy.app"]
  end
end
