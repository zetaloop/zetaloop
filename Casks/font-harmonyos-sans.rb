cask "font-harmonyos-sans" do
  version "2.040"
  sha256 "5440a3d9337828eda72e35f48fbb246873bca26e89644d433a8b01b85e45ef85"

  url "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyManage/011/111/111/0000000000011111111.20260627152129.89276966309836366526585265125586:50001231000000:2800:A0161E048334FE0271F9F5ECBBD5070D17381C7846125F4D7109DBC7B532C715.zip?needInitFileName=true"
  name "HarmonyOS Sans"
  desc "HarmonyOS Sans font families"
  homepage "https://developer.huawei.com/consumer/cn/design/resource/"

  livecheck do
    skip "No version information available"
  end

  font "HarmonyOS Sans/HarmonyOS_Sans.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_Condensed.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_Condensed_Italic.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_Italic.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_Naskh_Arabic.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_Naskh_Arabic_UI.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_SC.ttf"
  font "HarmonyOS Sans/HarmonyOS_Sans_TC.ttf"
end
