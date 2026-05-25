# nix/modules/darwin.nix — auto-generated from bevy_winit.caixa.lisp
{ config, lib, pkgs, ... }:
let cfg = config.services.bevy_winit; in {
  options.services.bevy_winit = {
    enable = lib.mkEnableOption "bevy_winit";
    package = lib.mkOption { type = lib.types.package; default = pkgs.bevy_winit or null; };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
