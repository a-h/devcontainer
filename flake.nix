{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # az (Azure CLI)
  # helm
  # kubectl
  # tmux
  # git
  # ranger (file manager)
  # vim

  outputs = { self, nixpkgs, xc }: {
    packages."x86_64-linux".default = let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      in pkgs.buildEnv {
        name = "packages";
        paths = with pkgs; [
          cowsay
          xc.packages."x86_64-linux".xc
        ];
      };
  };
}
