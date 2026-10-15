{
  lib,
  fetchurl,
  mkFont,
}:

let
  version = "2.040";
in
mkFont {
  pname = "font-harmonyos-sans";
  inherit version;
  src = fetchurl {
    name = "HarmonyOS-Sans.zip";
    url = "https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtyManage/011/111/111/0000000000011111111.20260627152129.89276966309836366526585265125586:50001231000000:2800:A0161E048334FE0271F9F5ECBBD5070D17381C7846125F4D7109DBC7B532C715.zip?needInitFileName=true";
    hash = "sha256-VECj2TN4KO2nLjX0j7skaHO8om6JZE1DOosBuF5F74U=";
  };

  fontDirectories = [
    "HarmonyOS Sans"
  ];

  passthru.fontSource = {
    primary = "HarmonyOS_Sans.ttf";
  };

  meta = {
    description = "HarmonyOS Sans font families";
    homepage = "https://developer.huawei.com/consumer/cn/design/resource/";
    license = lib.licenses.unfree;
  };
}
