{
  description = "mc-website — Next.js standalone app packaged as a NixOS service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      # NixOS module — works on any system, defined outside the per-system loop.
      nixosModule =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.services.mc-website;
        in
        {
          options.services.mc-website = {
            enable = lib.mkEnableOption "mc-website Next.js server";

            package = lib.mkOption {
              type = lib.types.package;
              default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
              defaultText = lib.literalExpression "mc-website.packages.\${system}.default";
              description = "The mc-website package to run.";
            };

            host = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0";
              description = "Address the server binds to.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 3000;
              description = "Port the server listens on.";
            };

            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to open the configured port in the firewall.";
            };

            environment = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = { };
              example = {
                NEXT_PUBLIC_FOO = "bar";
              };
              description = "Extra environment variables passed to the service.";
            };
          };

          config = lib.mkIf cfg.enable {
            systemd.services.mc-website = {
              description = "mc-website Next.js server";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];

              environment = {
                NODE_ENV = "production";
                NEXT_TELEMETRY_DISABLED = "1";
                HOSTNAME = cfg.host;
                PORT = toString cfg.port;
              } // cfg.environment;

              serviceConfig = {
                ExecStart = lib.getExe cfg.package;
                Restart = "on-failure";
                RestartSec = 5;

                # Hardening — the app is stateless static + SSR, needs no writable state.
                DynamicUser = true;
                NoNewPrivileges = true;
                ProtectSystem = "strict";
                ProtectHome = true;
                PrivateTmp = true;
                PrivateDevices = true;
                ProtectKernelTunables = true;
                ProtectKernelModules = true;
                ProtectControlGroups = true;
                RestrictAddressFamilies = [
                  "AF_INET"
                  "AF_INET6"
                ];
                RestrictNamespaces = true;
                LockPersonality = true;
                MemoryDenyWriteExecute = false; # Node JIT needs W+X
                SystemCallArchitectures = "native";
              };
            };

            networking.firewall = lib.mkIf cfg.openFirewall {
              allowedTCPPorts = [ cfg.port ];
            };
          };
        };
    in
    {
      nixosModules.default = nixosModule;
      nixosModules.mc-website = nixosModule;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) lib;

        mc-website = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "mc-website";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = [
            pkgs.nodejs
            pkgs.pnpm
            pkgs.pnpmConfigHook
            pkgs.makeWrapper
          ];

          pnpmDeps = pkgs.fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            fetcherVersion = 3;
            hash = "sha256-sruw4seY0JpLOL6iFhJciGK7d8D7DX2V83z5iPs4No4=";
          };

          env.NEXT_TELEMETRY_DISABLED = "1";

          # Next.js standalone bundles a trimmed pnpm node_modules tree that
          # contains a few dangling symlinks (e.g. semver). They are unused at
          # runtime, so skip the broken-symlink fixup check.
          dontCheckForBrokenSymlinks = true;

          buildPhase = ''
            runHook preBuild
            pnpm build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/share/mc-website
            cp -r .next/standalone/. $out/share/mc-website/
            mkdir -p $out/share/mc-website/.next
            cp -r .next/static $out/share/mc-website/.next/static
            cp -r public $out/share/mc-website/public

            makeWrapper ${lib.getExe pkgs.nodejs} $out/bin/mc-website \
              --add-flags $out/share/mc-website/server.js \
              --set-default PORT 3000 \
              --set-default HOSTNAME 0.0.0.0

            runHook postInstall
          '';

          meta = {
            description = "mc-website Next.js standalone server";
            homepage = "https://github.com/Young-TW/mc-website";
            mainProgram = "mc-website";
            platforms = lib.platforms.linux;
          };
        });
      in
      {
        packages.default = mc-website;
        packages.mc-website = mc-website;

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nodejs
            pkgs.pnpm
            pkgs.just
          ];
        };
      }
    );
}
