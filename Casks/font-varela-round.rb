cask "font-varela-round" do
  version "3.010"
  sha256 "e1e47eb66dbc2ddc106661338e712d9176c9e83c669a82fde155324823d03aa2"

  url "https://raw.githubusercontent.com/google/fonts/1866b1b967b78211927c48c9835099c33fb85b3b/ofl/varelaround/VarelaRound-Regular.ttf"
  name "Varela Round"
  desc "Rounded sans-serif font for display and small sizes"
  homepage "https://fonts.google.com/specimen/Varela+Round"

  livecheck do
    skip "No version information available"
  end

  font "VarelaRound-Regular.ttf"
end
