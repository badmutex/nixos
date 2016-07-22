# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  # boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sata_nv" "usbhid" "usb_storage"  "zfs" ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "sr_mod" "zfs"];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  
  fileSystems."/boot" =
    { label = "boot";
      fsType = "ext4";
    };

  fileSystems."/" =
    { device = "tank/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "tank/home";
      fsType = "zfs";
    };

  swapDevices =[ { label = "swap"; } ];

  nix.maxJobs = lib.mkDefault 8;
}
