class Ilspycmd < Formula
  desc "Command-line .NET assembly decompiler"
  homepage "https://github.com/icsharpcode/ILSpy"
  url "https://api.nuget.org/v3-flatcontainer/ilspycmd/11.1.0.9782/ilspycmd.11.1.0.9782.nupkg"
  sha256 "74c07facaf1850c78a779fc509031f756e1c0de24b1a536f3363d7ef81ce001f"
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
