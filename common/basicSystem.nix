{ pkgs, config, ... }:
{

  imports = [
    ./nix-config.nix
  ];

  ################################################################################
  # environment
  boot.cleanTmpDir = true;

  programs.bash.enableCompletion = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;

  environment.systemPackages = with pkgs;
       [ file htop hwdata iotop lsof lshw lsscsi nethogs pciutils psmisc which smartmontools xsettingsd usbutils bind inetutils ]
    ++ [ nix-serve nix-prefetch-git nix-prefetch-hg nix-prefetch-svn nix-prefetch-scripts ]
    ++ [ wget curl ]
    ++ [ vim emacs25-nox ]
    ++ [ gitAndTools.gitFull ]
    ++ [ mkpasswd ];

  environment.variables = {
    HOST     = config.networking.hostName;
    HOSTNAME = config.networking.hostName;
  };

  ################################################################################
  # networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  ################################################################################
  # security
  networking.tcpcrypt.enable = false;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # TODO security.hideProcessInformation = true;
  security.pam.enableSSHAgentAuth = true;
  security.polkit.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.permitRootLogin = "no";

  ################################################################################
  # services
  services.atd.enable = false;
  services.avahi.enable = false;
  services.locate.enable = false;
  services.ntp.enable = true;
  services.smartd.enable = true;
  services.openssh.enable = true;

  ################################################################################
  # system
  powerManagement.enable = true;
  system.autoUpgrade.enable = true;

  system.stateVersion = "16.03";
  time.timeZone = "US/Eastern";

}
