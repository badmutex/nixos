{ config, pkgs, ... }:

# let
#   packageChoices.withChrome = true;
# in

{

  imports = [
    ./fangorn/hardware-configuration.nix

    ./common/basicSystem.nix
    ./common/workstation.nix
    ./common/desktopManager.nix
    ./common/auto-upgrade.nix
    # ./common/bluetooth.nix
    ./common/firefox-nightly.nix
    ./common/nvidia.nix
    ./common/users.nix
    ./common/yubikey.nix
    ./common/virthost.nix
    ./common/vpn.nix
    ./common/popfile.nix
    ./common/syncthing.nix
  ];

  services.openvpn.servers.nordvpn.autoStart = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_840_EVO_250GB_S1DBNSAF757040Z";

  networking.hostId = "f125f099";
  networking.hostName = "fangorn"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 3000 24800 111 2049 ];
  networking.firewall.allowedUDPPorts = [ 111 2049 ];
  networking.firewall.allowedTCPPortRanges = [ { from = 9000; to = 9100; } ];   #  to monkey around with

  fileSystems."/home/badi/mandos" = {
    device = "//10.0.0.2/mandos";
    fsType = "cifs";
    options = [ "credentials=/var/lib/mandos/auth" "uid=badi" "gid=users" "auto"
                "x-systemd.automount"
                "x-systemd.mount-timeout=10s"
              ];
  };


  environment.systemPackages = with pkgs; [
    digikam gwenview okular
    keepassx-community

    google-chrome
    evince
    gimp
    inkscape
    spotify
    screen
    tmux
  ];


  services.synergy.server.enable = true;
  services.synergy.server.configFile = "/home/badi/.synergy.conf";

  services.grafana.enable = true;
  services.grafana.addr = "0.0.0.0";

  services.prometheus.enable = true;
  services.prometheus.nodeExporter.enable = true;
  # services.prometheus.nodeExporter.enabledCollectors = [];

  services.prometheus.blackboxExporter.enable = true;
  services.prometheus.blackboxExporter.openFirewall = true;
  services.prometheus.blackboxExporter.configFile = pkgs.writeTextFile {
    name = "prometheus-blackbox.config";
    text = ''
      modules:
        icmp_check:
          prober: icmp
          timeout: 60s
          icmp:
            preferred_ip_protocol: ip4
    '';
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "prometheus";
      scrape_interval = "60s";
      static_configs = [
        { targets = [ "localhost:9090" ];
          labels = {};
        }
      ];
    }

    {
      job_name = "node";
      scrape_interval = "5s";
      static_configs = [
        { targets = [ "localhost:9100" ];
          labels  = { alias = "fangorn"; };
        }
        { targets = [ "10.0.0.2:9100" ];
          labels  = { alias = "namo"; };
        }
        { targets = [ "10.0.0.10:9100" ];
          labels  = { alias = "glaurung"; };
        }
      ];
    }

    {
      job_name = "blackbox";
      scrape_interval = "60s";
      metrics_path = "/probe";
      params = { module = [ "icmp_check" ]; };
      static_configs = [
        { targets = [ "192.168.100.1" ];
          labels = { network = "internal"; what = "modem"; };
        }
        { targets = [ "10.0.0.1" "10.0.0.2" "10.0.0.10" "10.0.0.101" ];
          labels  = { network = "internal"; };
        }
        { targets = [ "google.com" "amazon.com" "spotify.com" "comcast.com" ];
          labels = { network = "external"; };
        }
      ];
      relabel_configs = [
        { source_labels = [ "__address__" ];
          target_label  = "__param_target";
        }
        { source_labels = [ "__param_target" ];
          target_label  = "instance";
        }
        { target_label  = "__address__";
          replacement   = "127.0.0.1:9115";
          source_labels = [];
        }
      ];
    }

  ];

  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = "badi.sh";
    password = pkgs.lib.readFile /var/lib/dyndns/badi.sh.password;
    domain = "fangorn";
  };


  system.stateVersion = "16.03";

}
