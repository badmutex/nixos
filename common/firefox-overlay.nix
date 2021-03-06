{ config, pkgs, ... }:

let
  overlay = import "${pkgs.callPackage ./nixpkgs-mozilla.nix {}}/firefox-overlay.nix";
in

{

  nixpkgs.overlays = [
    (self: super: {
      firefox-overlay = (overlay self super).latest;
      # inherit ((firefox-overlay self super).latest) firefox-nightly-bin;
    })
  ];

}
