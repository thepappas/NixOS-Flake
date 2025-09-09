{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

{
  imports = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "standard";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  users.users.john = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "changeme"; # Replace with hashed password or use secrets
  };

  environment.systemPackages = with pkgs; [
    vim git wget curl firefox
  ];

  programs.home-manager.enable = true;

  home-manager.users.john = {
    home.stateVersion = "23.11";
    programs.zsh.enable = true;
    programs.git.enable = true;
    programs.firefox.enable = true;
  };

  system.stateVersion = "23.11";
}
