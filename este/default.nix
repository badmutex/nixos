{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ../common/basicSystem.nix
      ../common/desktopManager.nix
      # ../common/nvidia.nix
      ../common/nix-config.nix
      ../common/junk-blocker.nix
      ../common/users.nix
      ../common/vpn.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.displayManager.sddm.enable = lib.mkForce true;
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = lib.mkForce true;
  # services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.xmonad.enable = lib.mkForce false;

  services.xserver.desktopManager.gnome3.sessionPath = with pkgs; [
    chrome-gnome-shell
  ];

  networking.hostName = "este";

  environment.systemPackages = with pkgs; [

    emacs
    firefox-bin
    google-chrome
    keepassx-community
    libreoffice
    nextcloud-client
    okular
    syncthing-tray
    kolourpaint
    remmina
    shutter
    # wpsoffice

  ];


  users.extraUsers.mandos = {
    isNormalUser = false;
    group = "mandos";
  };

  users.extraGroups."mandos" = {
     members = [ "badi" "melissa" ];
  };

  fileSystems."/mandos" = {
    device = "//namo/mandos";
    fsType = "cifs";
    options = [
      "ro"
      "credentials=/var/lib/mandos/auth" "uid=mandos" "gid=mandos"
      "x-systemd.automount"
      "x-systemd.device-timeout=30s"
      "x-systemd.mount-timeout=10s"
    ];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    powerDownCommands = "modprobe -r psmouse";
    powerUpCommands = "modprobe psmouse";
  };


  services.openvpn.servers.streisand.autoStart = false;

  services.syncthing = {
    enable = true;
    user = "melissa";
    dataDir = "/home/melissa/.syncthing";
    openDefaultPorts = true;
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ hplip ];

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.openFirewall = true;

  services.xserver.libinput = {
    enable = true;
    accelSpeed = "-0.8";
    clickMethod = "clickfinger";
    disableWhileTyping = true;
  };

  # https://wayland.freedesktop.org/libinput/doc/1.10.0//absolute_coordinate_ranges.html
  services.udev.extraRules = ''
    # Thinkpad T540P
    evdev:name:SynPS/2 Synaptics TouchPad:dmi:*svnLENOVO*:pv*ThinkPad*T540**
      EVDEV_ABS_00=1266:5675:44
      EVDEV_ABS_01=1171:4686:46
      EVDEV_ABS_35=1266:5675:44
      EVDEV_ABS_36=1171:4686:46
  '';

  users.extraUsers.melissa = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$yQ/gOzSE$LX58qHAXQ/Ug0sYdG624F0J9Bh6rc1IngDdNA2ijV/qkO8SoakJa1uHJ6DnPyNz7tm.nPKDPFB5wCkjlLj.yE.";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
