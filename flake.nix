{
    description = "Flake for the IISERM Thesis Template";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
        systems.url = "github:nix-systems/default";
        flake-utils = {
            url = "github:numtide/flake-utils";
            inputs.systems.follows = "systems";
        };
        pre-commit-hooks = {
            url = "github:cachix/git-hooks.nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        utpm.url = "github:typst-community/utpm";
    };

    outputs =
        {
            self,
            nixpkgs,
            flake-utils,
            pre-commit-hooks,
            ...
        }@inputs:
        flake-utils.lib.eachDefaultSystem (
            system:
            let
                pkgs = import nixpkgs { inherit system; };
            in
            {
                formatter = pkgs.treefmt.withConfig {
                    runtimeInputs = with pkgs; [
                        nixfmt
                        typstyle
                    ];
                    settings.formatter = {
                        nixfmt = {
                            command = "nixfmt";
                            includes = [ "*.nix" ];
                            options = [ "--indent=4" ];
                        };
                        typstyle = {
                            command = "typstyle";
                            includes = [ "*.typ" ];
                            options = [
                                "--inplace"
                                "--indent-width"
                                "4"
                            ];
                        };
                    };
                };

                checks = {
                    pre-commit-check = pre-commit-hooks.lib.${system}.run {
                        src = ./.;
                        hooks = {
                            flake-checker = {
                                enable = true;
                                after = [ "treefmt-nix" ];
                            };
                            treefmt = {
                                enable = true;
                                package = self.formatter.${system};
                            };
                        };
                    };
                };

                devShells.default = pkgs.mkShell {
                    inherit (self.checks.${system}.pre-commit-check) shellHook;

                    buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

                    packages =
                        with pkgs;
                        [
                            typst
                        ]
                        ++ [
                            inputs.utpm.packages.${system}.default
                        ];

                    TYPST_IGNORE_SYSTEM_FONTS = "true";
                    # Also set "tinymist.systemFonts": false
                };
            }
        );
}
