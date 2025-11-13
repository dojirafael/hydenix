{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.gaming;
in
{
  options.hydenix.gaming = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.enable && pkgs.stdenv.isx86_64;
      description = "Enable gaming module (x86_64 only)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && !pkgs.stdenv.isx86_64) {
      assertions = [
        {
          assertion = false;
          message = "hydenix.gaming is only supported on x86_64-linux systems. Steam and related gaming tools require 32-bit support which is not available on aarch64.";
        }
      ];
    })
    (lib.mkIf (cfg.enable && pkgs.stdenv.isx86_64) {
    environment.systemPackages = with pkgs; [
      mangohud # Performance monitoring overlay for games
      lutris # Game manager for Linux
    ];

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    })
  ];
}
