cask "font-alibaba-puhuiti" do
  version "3.0"
  sha256 "f25f730b6a7661bcd5b9764dc98f05d3ac25ee771977cf04b31ed5fba9f496a7"

  url "https://fonts.alibabadesign.com/AlibabaPuHuiTi-3.zip",
      verified: "fonts.alibabadesign.com/",
      referer:  "https://www.alibabafonts.com/"
  name "Alibaba PuHuiTi 3"
  desc "Alibaba PuHuiTi Chinese sans-serif family"
  homepage "https://www.alibabafonts.com/"

  livecheck do
    skip "No version information available"
  end

  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-35-Thin/AlibabaPuHuiTi-3-35-Thin.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-45-Light/AlibabaPuHuiTi-3-45-Light.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-55-Regular/AlibabaPuHuiTi-3-55-Regular.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-55-RegularL3/AlibabaPuHuiTi-3-55-RegularL3.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-65-Medium/AlibabaPuHuiTi-3-65-Medium.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-75-SemiBold/AlibabaPuHuiTi-3-75-SemiBold.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-85-Bold/AlibabaPuHuiTi-3-85-Bold.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-95-ExtraBold/AlibabaPuHuiTi-3-95-ExtraBold.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-105-Heavy/AlibabaPuHuiTi-3-105-Heavy.ttf"
  font "AlibabaPuHuiTi-3/AlibabaPuHuiTi-3-115-Black/AlibabaPuHuiTi-3-115-Black.ttf"
end
