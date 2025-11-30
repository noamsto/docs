{
  description = "Factify Documentation Site - Developer documentation built with Mintlify";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {
    flake-parts,
    systems,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        # Speakeasy CLI binary (fetch from GitHub releases)
        speakeasy = pkgs.stdenv.mkDerivation rec {
          pname = "speakeasy";
          version = "1.665.0";

          src = pkgs.fetchurl {
            url = "https://github.com/speakeasy-api/speakeasy/releases/download/v${version}/speakeasy_linux_amd64.zip";
            sha256 = "083x043yzinnhiakby1dd46vbama5v1zx425kpi4278kg2rvpyrh";
          };

          nativeBuildInputs = [pkgs.unzip];

          unpackPhase = ''
            unzip $src
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp speakeasy $out/bin/
            chmod +x $out/bin/speakeasy
          '';

          meta = with pkgs.lib; {
            description = "Speakeasy CLI for generating SDKs from OpenAPI specs";
            homepage = "https://github.com/speakeasy-api/speakeasy";
            license = licenses.asl20;
            platforms = platforms.linux;
          };
        };
      in {
        devShells.default = pkgs.mkShell {
          name = "factify-docs";

          packages = with pkgs; [
            # Node.js v22 (meets v19+ requirement)
            nodejs_22

            # Package managers
            nodePackages.npm
            nodePackages.pnpm
            nodePackages.yarn

            # Development tools
            git

            # Speakeasy CLI
            speakeasy
          ];

          env = {
            NPM_CONFIG_PREFIX = "$PWD/.npm-global";
            NODE_ENV = "development";
          };

          shellHook = ''
            # Add npm global bin to PATH
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"

            echo "🚀 Factify Documentation Development Environment"
            echo ""
            echo "Node version: $(node --version)"
            echo "npm version: $(npm --version)"
            echo "Speakeasy version: $(speakeasy --version 2>&1 | head -1)"
            echo ""

            # Check if Mintlify CLI is installed
            if ! command -v mint &> /dev/null; then
              echo "📦 Installing Mintlify CLI..."
              npm install -g mint
              echo ""
            else
              echo "✅ Mintlify CLI is installed"
              echo ""
            fi

            echo "Available commands:"
            echo "  mint dev              - Start local preview at http://localhost:3000"
            echo "  mint broken-links     - Validate all documentation links"
            echo "  speakeasy quickstart  - Interactive SDK generation setup"
            echo "  speakeasy generate    - Generate SDK from OpenAPI spec"
            echo ""
            echo "📚 Documentation:"
            echo "  Mintlify:  https://mintlify.com/docs"
            echo "  Speakeasy: https://www.speakeasy.com/docs"
            echo ""
          '';
        };

        # Formatter for 'nix fmt'
        formatter = pkgs.alejandra;
      };
    };
}
