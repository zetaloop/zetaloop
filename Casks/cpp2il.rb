cask "cpp2il" do
  arch arm: "-ARM64"

  version "2022.1.0-pre-release.21"
  sha256 arm:   "6670ddb93f28d4e7f329251d2597d2abbc6ba23e46382f7ca7b5e437ec93606a",
         intel: "15faab020698512807f792aef32a89fe529d41d2cc03955dd3516f0519fe8f72"

  url "https://github.com/SamboyCoding/Cpp2IL/releases/download/#{version}/Cpp2IL-#{version}-OSX#{arch}"
  name "Cpp2IL"
  desc "Reverse Unity's IL2CPP build process"
  homepage "https://github.com/SamboyCoding/Cpp2IL"

  livecheck do
    url "https://github.com/SamboyCoding/Cpp2IL.git"
    regex(/^(\d+(?:\.\d+)+(?:-pre-release\.\d+)?)$/i)
  end

  container type: :naked

  binary "Cpp2IL-#{version}-OSX#{arch}", target: "cpp2il"

  postflight_steps do
    run "/usr/bin/xattr",
        args: ["-dr", "com.apple.quarantine", "{{staged_path}}/Cpp2IL-#{version}-OSX#{arch}"]
  end
end
