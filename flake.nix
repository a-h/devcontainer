{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, xc }: 
  let
    pkgs = nixpkgs.legacyPackages."x86_64-linux"; 
    env = pkgs.buildEnv {
        name = "packages";
        paths = with pkgs; [
          astyle # Code formatter for C.
          azure-cli # Azure CLI.
          azure-storage-azcopy # Azure CLI copy tool.
          bash # Standard CLI tooling.
          bat # Colourized cat.
          cargo # Rust tooling.
          coreutils # Standard tools - ls, pwd etc.
          ccls # C LSP Server.
          cmake # C tooling.
          d2 # Text-based diagramming tool.
          delve # Go debugger.
          docker # Container tooling.
          entr # Execute command when files change.
          fd # Find that respects .gitignore.
          fuse-overlayfs # Filesystem for rooless podman.
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
          ninja # Used by Raspberry Pi Pico SDK, build tool.
          nmap # Port scanner.
          nodejs-18_x # Node LTS version.
          podman # Docker alternative.
          podman-compose # Alternative to docker-compose.
          powerline # Status line UI fancy.
          python310Packages.python-lsp-server
          python311 # Python 3.11.
          ranger # File manager.
          ripgrep # Fast grep.
          rust-analyzer # Rust language server.
          rustc # Rust compiler.
          rustfmt # Rust formatter.
          shadow # Required to run podman containers in podman.
          silver-searcher # Fast grep (ag).
          sumneko-lua-language-server # LSP for Lua.
          terraform # Infrastructure management language.
          terraform-ls # Terraform Language Server.
          tflint # Terraform linting tool.
          tmux # Terminal multiplexer.
          tree # Tree of file systems.
          tunctl # Utility for controlling tuntap interfaces. Required to start podman containers with open ports.
          unzip # Unzip files.
          urlscan # Find URLs in your terminal
          wget # curl, but it follows links automatically etc.
          xc.packages."x86_64-linux".xc # Task manager.
          yarn # Alternative to NPM for JavaScript.
          zip # Zip files.
        ];
      };
    dockerImage = pkgs.dockerTools.buildImage {
      name = "devcontainer-nix";
      tag = "latest";
      runAsRoot = ''
        #!${pkgs.runtimeShell}
        ${pkgs.dockerTools.shadowSetup}
        groupadd -r -g 1000 vscode
        useradd -r -g vscode -u 1000 vscode
      '';
      copyToRoot = env;
      config = { Cmd = [ "/bin/bash" ]; };
      diskSize = 10240;
      buildVMMemorySize = 2048;
    };
  in
    {
      packages."x86_64-linux".default = env;
      packages."x86_64-linux".docker = dockerImage;
    };
}

