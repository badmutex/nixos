# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" =
    { device = "zfs/gambit/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zfs/gambit/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/d1b33578-d902-4bc8-ac63-c791fdd34be3";
      fsType = "ext4";
    };

  fileSystems."/tmp" =
    { device = "zfs/tmp";
      fsType = "zfs";
    };   

  swapDevices =
    [ { device = "/dev/disk/by-uuid/34d4b938-9426-49b7-aa27-eb7cfceb87f7"; }
    ];

  nix.maxJobs = 8;
}
