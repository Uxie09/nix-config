{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";

    nur.url = "github:nix-community/NUR";

    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
    impermanence.url = "github:RiscadoA/impermanence";

    nix-colors.url = "github:Misterio77/nix-colors";

    utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

  };

  outputs =
    { nixpkgs
    , home-manager
    , hardware
    , nur
    , declarative-cachix
    , impermanence
    , nix-colors
    , utils
    , ...
    }:
    let
      # Make system configuration, given hostname and system type
      mkSystem = { hostname, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit nixpkgs hardware nur declarative-cachix
              impermanence nix-colors system;
          };
          modules = [ (./hosts + "/${hostname}") ./modules/nixos ./overlays ];
        };
      # Make home configuration, given username, required features, and system type
      mkHome = { username, features, system }:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;
          extraSpecialArgs = {
            inherit nur impermanence nix-colors features;
          };
          configuration = ./users + "/${username}";
          extraModules = [ ./modules/home-manager ./overlays ];
          homeDirectory = "/home/${username}";
        };
    in
    {
      nixosConfigurations = {
        # Main PC
        atlas = mkSystem {
          hostname = "atlas";
          system = "x86_64-linux";
        };
        # Raspberry Pi 4B
        merope = mkSystem {
          hostname = "merope";
          system = "aarch64-linux";
        };
        # Gf's PC
        maia = mkSystem {
          hostname = "maia";
          system = "x86_64-linux";
        };
      };

      homeConfigurations = {
        "misterio@atlas" = mkHome {
          username = "misterio";
          features = [ "cli" "desktop-sway" "games" "mining" "persistence" "rgb" "trusted" ];
          system = "x86_64-linux";
        };
        "misterio@merope" = mkHome {
          username = "misterio";
          features = [ "cli" "persistence" ];
          system = "aarch64-linux";
        };
        "misterio@maia" = mkHome {
          username = "misterio";
          features = [ "cli" "persistence" ];
          system = "x86_64-linux";
        };

        "layla@maia" = mkHome {
          username = "layla";
          features = [ ];
          system = "x86_64-linux";
        };
      };

      overlay = import ./overlays;

      templates = import ./templates;

    } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ nixfmt rnix-lsp ];
      };
    });
}
