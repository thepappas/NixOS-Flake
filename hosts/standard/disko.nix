{ lib, ... }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                };
                "@home" = {
                  mountpoint = "/home";
                };
                "@nix" = {
                  mountpoint = "/nix";
                };
                "@swap" = {
                  mountpoint = "/swap";
                };
              };
            };
          };
        };
      };
    };
  };
}
