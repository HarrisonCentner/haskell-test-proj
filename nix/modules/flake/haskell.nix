# haskell-flake configuration goes in this module.

{ root, inputs, ... }:
{
  imports = [
    inputs.haskell-flake.flakeModule
  ];
  perSystem = { self', lib, config, pkgs, ... }: {
    # Our only Haskell project. You can have multiple projects, but this template
    # has only one.
    # See https://github.com/srid/haskell-flake/blob/master/example/flake.nix
    haskellProjects.default = {
      # To avoid unnecessary rebuilds, we filter projectRoot:
      # https://community.flake.parts/haskell-flake/local#rebuild
      projectRoot = builtins.toString (lib.fileset.toSource {
        inherit root;
        fileset = lib.fileset.unions [
          (root + /src)
          (root + /test-proj.cabal)
          (root + /LICENSE)
          (root + /README.md)
        ];
      });

      # The base package set (this value is the default)
      basePackages = pkgs.haskellPackages;

      # Packages to add on top of `basePackages`
      packages = {
        # Add source or Hackage overrides here
        # (Local packages are added automatically)
        /*
        aeson.source = "1.5.0.0" # Hackage version
        shower.source = inputs.shower; # Flake input
        */
        finitary.source = "2.2.0.0"; # Hackage version
        hspec-hedgehog.source = "0.2.0.0"; # Hackage version
        mmorph.source = "1.2.1"; # Hackage version
        free.source = "5.2"; # Hackage version
      };

      # Add your package overrides here
      settings = {
        test-proj = {
          stan = true;
          # haddock = false;
        };
        /*
        aeson = {
          check = false;
        };
        */
      };

      # What should haskell-flake add to flake outputs?
      autoWire = [ "packages" "apps" "checks" ]; # Wire all but the devShell
    };

    # Default package & app.
    packages.default = self'.packages.test-proj;
    apps.default = self'.apps.site;
  };
}
