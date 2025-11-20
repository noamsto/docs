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
      }: {
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
            echo "  mint dev --port 3333  - Start on custom port"
            echo "  mint broken-links     - Validate all documentation links"
            echo "  mint update           - Update Mintlify CLI to latest version"
            echo ""
            echo "📚 Documentation: https://mintlify.com/docs"
            echo ""
          '';
        };

        # Formatter for 'nix fmt'
        formatter = pkgs.alejandra;
      };
    };
}
