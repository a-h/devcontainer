{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, xc }: {
    packages."x86_64-linux".default = let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      in pkgs.buildEnv {
        name = "packages";
        paths = with pkgs; [
          astyle # Code formatter for C.
          azure-cli # Azure CLI.
          bat # Colourized cat.
          cargo # Rust tooling.
          ccls # C LSP Server.
          cmake # C tooling.
          d2 # Text-based diagramming tool.
          delve # Go debugger.
          docker # Container tooling.
          entr # Execute command when files change.
          fd # Find that respects .gitignore.
          fzf # Fuzzy search.
          gcc # Compiler.
          git # Source code management tool.
          gitAndTools.gh # Github CLI.
          gnupg # Tool for handling PGP encrypt/decrypt.
          go # Programming language.
          gopls # LSP for Go.
          gotools # Additional Go tooling.
          gradle # Build tool.
          graphviz # Build SVGs of graphs (maths graphs).
          htop # Fancy version of top.
          ibm-plex # Font.
          imagemagick # Image processing.
          jdk # Development.
          jq # JSON query at the CLI.
          jre # Runtime.
          kubectl # Kubernetes management tool.
          kubernetes-helm # Manage Kubernetes deployments.
          llvm # Used by Raspberry Pi Pico SDK.
          lua5_4 # Scripting language.
          maven # Java build tooling.
          minicom # Serial monitor.
          neovim # Better version of Vim.
          nerdfonts # Fonts with nerd glyphs for terminals.
          ninja # Used by Raspberry Pi Pico SDK, build tool.
          nmap # Port scanner.
          nodejs-18_x # Node LTS version.
          podman # Docker alternative.
          powerline # Status line UI fancy.
          python310Packages.python-lsp-server
          python311 # Python 3.11.
          ranger # File manager.
          ripgrep # Fast grep.
          rust-analyzer # Rust language server.
          rustc # Rust compiler.
          rustfmt # Rust formatter.
          silver-searcher # Fast grep (ag).
          source-code-pro # Font.
          sumneko-lua-language-server # LSP for Lua.
          terraform # Infrastructure management language.
          terraform-ls # Terraform Language Server.
          tflint # Terraform linting tool.
          tmux # Terminal multiplexer.
          tree # Tree of file systems.
          unzip # Unzip files.
          urlscan # Find URLs in your terminal
          wget # curl, but it follows links automatically etc.
          xc.packages."x86_64-linux".xc # Task manager.
          yarn # Alternative to NPM for JavaScript.
          zip # Zip files.
        ];
      };
  };
}
