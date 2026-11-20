{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = pkgs.callPackage ../pkgs/overcast.nix { };
in
{
  options.services.overcast.enable = lib.mkEnableOption "Overcast";

  config = lib.mkIf config.services.overcast.enable {
    environment.systemPackages = [ package ];
    systemd.services.overcast = {
      description = "Overcast";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.ConditionPathExists = "/var/lib/overcast/deployment.json";
      serviceConfig = {
        Type = "exec";
        ExecCondition = "${lib.getExe pkgs.jq} -e .config.running /var/lib/overcast/deployment.json";
        ExecStart = "${lib.getExe package} --run /var/lib/overcast";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        KillMode = "mixed";
        Restart = "on-failure";
      };
    };
  };
}
