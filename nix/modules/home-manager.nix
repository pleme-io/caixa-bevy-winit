# nix/modules/home-manager.nix — auto-generated from bevy_winit.caixa.lisp
{ config, lib, pkgs, ... }:
let cfg = config.programs.bevy_winit; in {
  options.programs.bevy_winit = {
    enable = lib.mkEnableOption "bevy_winit";
    package = lib.mkOption { type = lib.types.package; default = pkgs.bevy_winit or null; };
  };
  config = lib.mkIf cfg.enable { home.packages = [ cfg.package ]; };
}
