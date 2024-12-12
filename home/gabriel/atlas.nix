{
  pkgs,
  ...
}: {
  imports = [
    ./global
    ./features/desktop/hyprland
    ./features/desktop/wireless
    ./features/rgb
    ./features/productivity
    ./features/pass
    ./features/games
    ./features/games/star-citizen.nix
  ];

  # Purple
  wallpaper = pkgs.wallpapers.aenami-lost-in-between;

  #  ------   -----   ------
  # | DP-3 | | DP-1| | DP-2 |
  #  ------   -----   ------
  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1080;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      position = "auto-right";
      workspace = "2";
    }
  ];
}
