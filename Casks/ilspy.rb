cask "ilspy" do
  version "11.2.0.10050"
  sha256 "3f027113aa25dd16ed7d6fc6539f28fcc795026014f66772af40367a3db9093c"

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
