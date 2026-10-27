class Ilspycmd < Formula
  desc "Command-line .NET assembly decompiler"
  homepage "https://github.com/icsharpcode/ILSpy"
  url "https://api.nuget.org/v3-flatcontainer/ilspycmd.any/11.2.0.10050/ilspycmd.any.11.2.0.10050.nupkg"
  sha256 "d4015f1c63aa2211c1c692321ecc28f3c241ae586d441f50c5ac50383ad00388"
  license "MIT"

  livecheck do
    url "https://api.nuget.org/v3-flatcontainer/ilspycmd.any/index.json"
    strategy :json do |json|
      json["versions"]&.grep(/^\d+(?:\.\d+)+$/)&.last
    end
  end

  uses_from_macos "unzip" => :build

  def install
    system "unzip", "-q", "ilspycmd.any.#{version}.nupkg", "-d", "package"
    libexec.install Dir["package/tools/net10.0/any/*"]
    (bin/"ilspycmd").write_env_script "dotnet", [libexec/"ilspycmd.dll"], {}
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ilspycmd --version")
  end
end
