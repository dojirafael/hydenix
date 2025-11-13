{
  inputs,
  ...
}:
let
  system = "aarch64-linux";
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      inputs.self.overlays.default
    ];
  };
in
{

  nixpkgs.pkgs = pkgs;

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    inputs.self.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };

    users."hydenix" =
      { ... }:
      {
        imports = [
          inputs.self.homeModules.default
          ./home.nix
        ];
      };
  };

  hydenix = {
    enable = true;
    hostname = "hydenix";
    timezone = "America/Vancouver";
    locale = "en_CA.UTF-8";
  };

  users.users.hydenix = {
    isNormalUser = true;
    initialPassword = "hydenix";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";
}
