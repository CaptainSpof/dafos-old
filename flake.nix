{
  description = "dafos: daf's hosts";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";
    latest.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOs/nixos-hardware/master";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.latest.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";
    digga.inputs.deploy.follows = "deploy";

    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    deploy.url = "github:serokell/deploy-rs";
    deploy.inputs.nixpkgs.follows = "nixos";

    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
      ref = "master";
    };

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixos";

    nixos-generators.url = "github:nix-community/nixos-generators";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixos";
    plasma-manager.inputs.home-manager.follows = "home";
  };

  outputs = { self, nixos, latest, nixos-hardware, digga, home, agenix, deploy, nixos-generators, nur, nvfetcher, emacs-overlay, plasma-manager } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      channelsConfig.allowUnfree = true;
      channels.nixos = {
        imports = [ (digga.lib.importOverlays ./overlays) ];
        # REVIEW: checkout and setup nvfetcher
        overlays = [
          agenix.overlays.default
          nvfetcher.overlay
          emacs-overlay.overlays.default
          nur.overlay
          ./pkgs/default.nix
        ];
      };

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            agenix.nixosModules.age
            home.nixosModules.home-manager
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts) ];

        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles;
          suites = with builtins; let explodeAttrs = set: map (a: getAttr a set) (attrNames set); in
          with profiles; rec {
            base = (explodeAttrs core) ++ [ vars ];
            server = [ profiles.server vars core.cachix ];
            desktop =
              base
              ++ (explodeAttrs shell)
              ++ (explodeAttrs graphical)
              ++ (explodeAttrs pc)
              ++ (explodeAttrs hardware)
              ++ (explodeAttrs develop)
              ++ (explodeAttrs editors)
              ++ (explodeAttrs services);
            laptop = desktop ++ [ profiles.laptop ];
          };
        };

        hosts = {
          daftop.modules = [
            nixos-hardware.nixosModules.common-pc-ssd
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-pc-laptop-acpi_call
          ];
          dafpi.system = "aarch64-linux";
        };
      };

      devshell = ./shell;

      home.modules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      # TODO: finish setup
      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
        dafbox = {
          profilesOrder = [ "system" "daf" ];
          profiles.system.sshUser = "root";
          profiles.daf = {
            user = "daf";
            sshUser = "root";
            path = deploy.lib.x86_64-linux.activate.home-manager self.homeConfigurations."daf@dafbox";
          };
        };
        dafpi = {
          profiles.system.sshUser = "root";
        };
      };
    };
}
