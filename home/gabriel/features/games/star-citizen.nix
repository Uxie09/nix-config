{pkgs, ...}: {
  home.packages = [
    (pkgs.inputs.nix-gaming.star-citizen.override {disableEac = false;})
  ];
}
