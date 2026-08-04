cask "font-montserrat" do
  version "9.000"
  sha256 "991b3f971c65081c780fa15645a030bdf9e21ee8734b9f6010638b83bae1ff83"

  url "https://github.com/JulietaUla/Montserrat/archive/refs/tags/v#{version}.tar.gz"
  name "Montserrat"
  desc "Geometric sans-serif variable fonts with Montserrat Alternates"
  homepage "https://github.com/JulietaUla/Montserrat"

  livecheck do
    url "https://github.com/JulietaUla/Montserrat.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  font "Montserrat-#{version}/fonts/variable/Montserrat-Italic[wght].ttf"
  font "Montserrat-#{version}/fonts/variable/Montserrat[wght].ttf"
  font "Montserrat-#{version}/fonts-alternates/variable/MontserratAlternates-Italic[wght].ttf"
  font "Montserrat-#{version}/fonts-alternates/variable/MontserratAlternates[wght].ttf"
end
