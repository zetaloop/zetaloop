cask "font-varela" do
  version "1.000"
  sha256 "87cf0ddd50cd297cd6facfaac8bf59bf8d0b1a3b8b6619957ba08e72043d1896"

  url "https://raw.githubusercontent.com/google/fonts/90abd17b4f97671435798b6147b698aa9087612f/ofl/varela/Varela-Regular.ttf"
  name "Varela"
  desc "Sans-serif font for display and small sizes"
  homepage "https://fonts.google.com/specimen/Varela"

  livecheck do
    skip "No version information available"
  end

  font "Varela-Regular.ttf"
end
