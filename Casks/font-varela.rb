cask "font-varela" do
  version "90abd17b4f97671435798b6147b698aa9087612f"
  sha256 "87cf0ddd50cd297cd6facfaac8bf59bf8d0b1a3b8b6619957ba08e72043d1896"

  url "https://raw.githubusercontent.com/google/fonts/#{version}/ofl/varela/Varela-Regular.ttf",
      verified: "raw.githubusercontent.com/google/fonts/"
  name "Varela"
  desc "Sans-serif font for display and small sizes"
  homepage "https://fonts.google.com/specimen/Varela"

  livecheck do
    url "https://api.github.com/repos/google/fonts/commits?path=ofl%2Fvarela%2FVarela-Regular.ttf&per_page=1"
    strategy :json do |json|
      json.first&.dig("sha")
    end
  end

  font "Varela-Regular.ttf"
end
