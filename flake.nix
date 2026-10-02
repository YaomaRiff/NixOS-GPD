{
  description = "NixOS configuration with Flakes";

  inputs = {
    nixpkgs.url = "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-26.05.tar.gz";
    nixpkgs-unstable.url = "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    
    home-manager.url = "https://ghfast.top/https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
    zen-browser.url = "https://ghfast.top/https://github.com/0xc000022070/zen-browser-flake/archive/main.tar.gz";
    
    treesnap = {
      url = "https://ghfast.top/https://github.com/YaomaRiff/treesnap/archive/nixos.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 雾凇拼音词库（纯数据仓库，不是 flake）
    rime-ice.url = "github:iDvel/rime-ice";
    rime-ice.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, zen-browser, treesnap, rime-ice, ... }:
    let
      system = "x86_64-linux";
      
      # 从 unstable 提取最新内核和 Web UI，覆盖稳定版
      overlay-unstable-tools = final: prev: {
        mihomo = nixpkgs-unstable.legacyPackages.${system}.mihomo;
        metacubexd = nixpkgs-unstable.legacyPackages.${system}.metacubexd;
        zed-editor = nixpkgs-unstable.legacyPackages.${system}.zed-editor;
      };

      commonModules = [
        ./system/configuration.nix
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ overlay-unstable-tools ];
          environment.systemPackages = [
            treesnap.packages.${pkgs.system}.default
          ];
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.Traversal = import ./home;
          home-manager.extraSpecialArgs = {
            inherit zen-browser;
            inherit system;
            inherit rime-ice;
          };
        }
      ];
    in {
      nixosConfigurations = {
        lab = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit zen-browser; };
          modules = [
            ./hosts/lab/hardware-configuration.nix
            { networking.hostName = "lab"; }
          ] ++ commonModules;
        };

        panasonic = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit zen-browser; };
          modules = [
            ./hosts/panasonic/hardware-configuration.nix
            { networking.hostName = "panasonic"; }
          ] ++ commonModules;
        };

        gpdmax2 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit zen-browser; };
          modules = [
            ./hosts/gpdmax2/hardware-configuration.nix
            { networking.hostName = "gpdmax2"; }
          ] ++ commonModules;
        };
      };
    };
}
