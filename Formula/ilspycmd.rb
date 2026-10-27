class Ilspycmd < Formula
  desc "Command-line .NET assembly decompiler"
  homepage "https://github.com/icsharpcode/ILSpy"
  url "https://api.nuget.org/v3-flatcontainer/ilspycmd/11.2.0.10050/ilspycmd.11.2.0.10050.nupkg"
  sha256 "3196165768e5a818f8e8f101f999aa9cd2808a8f9568ae1c4998bbbcc68a5953"
  license "MIT"

  livecheck do
    url "https://api.nuget.org/v3-flatcontainer/ilspycmd/index.json"
    strategy :json do |json|
      json["versions"]&.grep(/^\d+(?:\.\d+)+$/)&.last
    end
  end

  uses_from_macos "unzip" => :build

  def install
    system "unzip", "-q", "ilspycmd.#{version}.nupkg", "-d", "package"
    libexec.install Dir["package/tools/net10.0/any/*"]
    (bin/"ilspycmd").write_env_script "dotnet", [libexec/"ilspycmd.dll"], {}
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ilspycmd --version")
  end
end
