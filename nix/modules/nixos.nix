# nix/modules/nixos.nix — auto-generated from bevy_winit.caixa.lisp
# description: "A winit window and input backend for Bevy Engine"
{ config, lib, pkgs, ... }:
let
  cfg = config.services.bevy_winit;
in {
  options.services.bevy_winit = {
    enable = lib.mkEnableOption "bevy_winit";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bevy_winit or null;
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
