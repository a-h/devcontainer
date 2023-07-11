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
    localPodman = import ./podman.nix {
      pkgs = pkgs;
    };
    env = pkgs.buildEnv {
        name = "packages";
        paths = with pkgs; [
          # Devcontainer requirements.
          getent # Used by devcontainers at startup to list users.
          coreutils # Standard tools - ls, pwd etc.
          which
          shadow
          libcap # setcap

          localPodman
          # Container related tooling.
          #fuse-overlayfs # Filesystem for rooless podman.
          podman # Docker alternative.
          #tunctl # Utility for controlling tuntap interfaces. Required to start podman containers with open ports.
          #podman-compose # Alternative to docker-compose.
          #shadow # Required to run podman containers in podman.
          #libcap # Required to run setcap.
          #which # Find the location of files.

           #     conmon
     # cni
     # cni-plugins # https://github.com/containers/podman/issues/3679
     # file
     # podman
     # libcap
     # runc
     # skopeo
     # slirp4netns
     # shadow
     # dbus
     # unixtools.whereis 

          # Tooling.
          #astyle # Code formatter for C.
          #azure-cli # Azure CLI.
          #azure-storage-azcopy # Azure CLI copy tool.
          #bat # Colourized cat.
          #cargo # Rust tooling.
          #ccls # C LSP Server.
          #cmake # C tooling.
          #d2 # Text-based diagramming tool.
          #delve # Go debugger.
      #    docker # Container tooling.
          #entr # Execute command when files change.
          #fd # Find that respects .gitignore.
          #fzf # Fuzzy search.
          #gcc # Compiler.
          #git # Source code management tool.
          #gitAndTools.gh # Github CLI.
          #gnupg # Tool for handling PGP encrypt/decrypt.
          #go # Programming language.
          #gopls # LSP for Go.
          #gotools # Additional Go tooling.
          #gradle # Build tool.
          #graphviz # Build SVGs of graphs (maths graphs).
          #htop # Fancy version of top.
          #imagemagick # Image processing.
          #jdk # Development.
          #jq # JSON query at the CLI.
          #jre # Runtime.
     #     #kubectl # Kubernetes management tool.
          #kubernetes-helm # Manage Kubernetes deployments.
          #llvm # Used by Raspberry Pi Pico SDK.
          #lua5_4 # Scripting language.
          #maven # Java build tooling.
          #minicom # Serial monitor.
          #neovim # Better version of Vim.
          #ninja # Used by Raspberry Pi Pico SDK, build tool.
          #nmap # Port scanner.
          #nodejs-18_x # Node LTS version.
          #powerline # Status line UI fancy.
          #python310Packages.python-lsp-server
          #python311 # Python 3.11.
          #ranger # File manager.
          #ripgrep # Fast grep.
          #rust-analyzer # Rust language server.
          #rustc # Rust compiler.
          #rustfmt # Rust formatter.
          #silver-searcher # Fast grep (ag).
          #sumneko-lua-language-server # LSP for Lua.
          #terraform # Infrastructure management language.
          #terraform-ls # Terraform Language Server.
          #tflint # Terraform linting tool.
          #tmux # Terminal multiplexer.
          #tree # Tree of file systems.
          #unzip # Unzip files.
          #urlscan # Find URLs in your terminal
          #wget # curl, but it follows links automatically etc.
          curl # curl
          #xc.packages."x86_64-linux".xc # Task manager.
          #yarn # Alternative to NPM for JavaScript.
          #zip # Zip files.
        ];
      };
    baseImage = pkgs.dockerTools.pullImage {
      imageName = "mcr.microsoft.com/devcontainers/base";
      imageDigest = "sha256:74f9743675319244249f535bc81f6628b2eab5d14ef11c5c28430de5b95f4d94";
      sha256 = "0m7r5196pwvlx4rhgv00h0snxg26iblc465zpv37bvrgnjjfk3bk";
      finalImageName = "mcr.microsoft.com/devcontainers/base";
      finalImageTag = "buster";
      os = "linux";
      arch = "amd64";
    };
    dockerImage = pkgs.dockerTools.buildImage {
      name = "devcontainer-nix";
      tag = "latest";

      #fromImage = baseImage;

      runAsRoot = ''
        #!${pkgs.runtimeShell}
        ${pkgs.dockerTools.shadowSetup}

        # Create vscode user.
        groupadd -g 1000 vscode
        useradd -g vscode -u 1000 vscode

        # Required by Devcontainers.
        echo "nix" > /etc/os-release

        # Create missing temp directories in home.
        mkdir -p /home/vscode/rundir/libpod
        mkdir -p /home/vscode/.local/share/containers/storage
        chown vscode:vscode -R /home/vscode

        # Create missing temp directory.
        mkdir -p /tmp/containers-user-1000
        chown vscode:vscode /tmp/containers-user-1000

        # Provide Podman uid and gid mapping.
        #mkdir -p /etc/
        #echo "vscode:1:999\nvscode:1001:64535" > /etc/subuid
        #echo "vscode:1:999\nvscode:1001:64535" > /etc/subgid

        # Provide capabilities to mapping.
        #setcap cap_setuid=ep /nix/store/vbi7srfk059k9xhb9irwp3y62m0b87jg-shadow-4.13/bin/newuidmap
        #setcap cap_setgid=ep /nix/store/vbi7srfk059k9xhb9irwp3y62m0b87jg-shadow-4.13/bin/newgidmap
        #NEWUIDMAP=$(readlink --canonicalize $(which newuidmap))
        #NEWGIDMAP=$(readlink --canonicalize $(which newgidmap))

        #setcap cap_setuid+ep "$NEWUIDMAP"
        #setcap cap_setgid+ep "$NEWGIDMAP"

        #chmod -s "$NEWUIDMAP"
        # chmod -s "$NEWGIDMAP"
      '';
      copyToRoot = with pkgs.dockerTools; [
        usrBinEnv
        binSh
        caCertificates
        ./root/.
        env
      ];
      config = { 
        Cmd = [ "/bin/sh" ]; 
        User = "vscode:vscode";
      };
      diskSize = 10240;
      buildVMMemorySize = 2048;
    };
  in
    {
      packages."x86_64-linux".default = env;
      packages."x86_64-linux".docker = dockerImage;
    };
}

