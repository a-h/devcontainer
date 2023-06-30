{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  # az (Azure CLI)
  # helm
  # kubectl
  # tmux
  # git
  # ranger (file manager)
  # vim

  outputs = { self, nixpkgs }: {
    packages."x86_64-linux".default = let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [
        cowsay
      ];
    };
  };
}
