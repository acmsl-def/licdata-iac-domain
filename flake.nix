# flake.nix
#
# This file packages licdata-iac as a Nix flake.
#
# Copyright (C) 2024-today acm-sl's licdata
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Nix flake for acmsl/licdata-iac";
  inputs = rec {
    acmsl-licdata-artifact-events = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events/0.0.3";
    };
    acmsl-licdata-artifact-events-infrastructure = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.acmsl-licdata-artifact-events.follows = "acmsl-licdata-artifact-events";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events-infrastructure/0.0.3";
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    acmsl-licdata = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:acmsl-def/licdata-def/0.0.9?dir=rest";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      inputs.pythoneda-shared-pythonlang-infrastructure.follows =
        "pythoneda-shared-pythonlang-infrastructure";
      inputs.pythoneda-shared-pythonlang-application.follows =
        "pythoneda-shared-pythonlang-application";
    };
    pythoneda-iac-events = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-iac-def/events/0.0.1";
    };
    pythoneda-iac-pulumi-azure = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-iac-events.follows = "pythoneda-iac-events";
      inputs.pythoneda-iac-shared.follows = "pythoneda-iac-shared";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-iac-def/pulumi-azure/0.0.3";
    };
    pythoneda-iac-shared = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-iac-def/shared/0.0.1";
    };
    pythoneda-shared-pythonlang-banner = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.69";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.84";
    };
    pythoneda-shared-pythonlang-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-def/infrastructure/0.0.61";
    };
    pythoneda-shared-pythonlang-application = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      inputs.pythoneda-shared-pythonlang-infrastructure.follows =
        "pythoneda-shared-pythonlang-infrastructure";
      url = "github:pythoneda-shared-pythonlang-def/application/0.0.81";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "acmsl";
        repo = "licdata-iac";
        version = "0.0.6";
        sha256 = "13qxq9r3ikdw416la29sav7m7vc2k1pk02kk6xjyfsd83dfxizpc";
        pname = "${org}-${repo}";
        pythonpackage = "org.acmsl.iac.licdata";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        pkgs = import nixos { inherit system; };
        description = "Licdata IaC";
        entrypoint = "licdata_iac_app";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = [ "rydnr <github@acm-sl.org>" ];
        archRole = "I";
        space = "D";
        layer = "A";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        licdata-iac-for = {
          licdata, python, pythoneda-iac-events, pythoneda-iac-pulumi-azure, pythoneda-iac-shared, pythoneda-shared-pythonlang-banner
          , pythoneda-shared-pythonlang-domain
          , pythoneda-shared-pythonlang-infrastructure
          , pythoneda-shared-pythonlang-application }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
            banner_file = "${package}/licdata_iac_banner.py";
            banner_class = "LicdataIacBanner";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTomlTemplate = ./templates/pyproject.toml.template;
            pyprojectToml = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage pname pythonMajorMinorVersion pythonpackage
                version;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              pythonedaIacEvents = pythoneda-iac-events.version;
              pythonedaIacPulumiAzure = pythoneda-iac-pulumi-azure.version;
              pythonedaIacShared = pythoneda-iac-shared.version;
              pythonedaSharedPythonlangBanner =
                pythoneda-shared-pythonlang-banner.version;
              pythonedaSharedPythonlangDomain =
                pythoneda-shared-pythonlang-domain.version;
              pythonedaSharedPythonlangInfrastructure =
                pythoneda-shared-pythonlang-infrastructure.version;
              pythonedaSharedPythonlangApplication =
                pythoneda-shared-pythonlang-application.version;
              pulumi = python.pkgs.pulumi.version;
              pulumiAzureNative = pkgs.python312Packages.pulumi-azure-native.version;
              src = pyprojectTomlTemplate;
            };
            bannerPyTemplate = ./templates/banner.py.template;
            bannerPy = pkgs.substituteAll {
              project_name = pname;
              file_path = banner_file;
              inherit banner_class org repo;
              tag = version;
              pescio_space = space;
              arch_role = archRole;
              hexagonal_layer = layer;
              python_version = pythonMajorMinorVersion;
              nixpkgs_release = nixpkgsRelease;
              src = bannerPyTemplate;
            };

            entrypointShTemplate =
              "${pythoneda-shared-pythonlang-banner}/templates/entrypoint.sh.template";
            entrypointSh = pkgs.substituteAll {
              arch_role = archRole;
              hexagonal_layer = layer;
              nixpkgs_release = nixpkgsRelease;
              inherit homepage maintainers org python repo version;
              pescio_space = space;
              python_version = pythonMajorMinorVersion;
              pythoneda_shared_pythoneda_banner =
                pythoneda-shared-pythonlang-banner;
              pythoneda_shared_pythoneda_domain =
                pythoneda-shared-pythonlang-domain;
              src = entrypointShTemplate;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = [ python.pkgs.pip python.pkgs.poetry-core pkgs.docker ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-iac-events
              pythoneda-iac-pulumi-azure
              pythoneda-iac-shared
              pythoneda-shared-pythonlang-banner
              pythoneda-shared-pythonlang-domain
              pythoneda-shared-pythonlang-infrastructure
              pythoneda-shared-pythonlang-application
              pulumi
              pulumi-azure-native
            ];

            # pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod -R +w $sourceRoot
              cp ${pyprojectToml} $sourceRoot/pyproject.toml
              cp ${bannerPy} $sourceRoot/${banner_file}
              cp ${entrypointSh} $sourceRoot/entrypoint.sh
            '';

            postPatch = ''
              substituteInPlace /build/$sourceRoot/entrypoint.sh \
                --replace "@SOURCE@" "$out/bin/${entrypoint}.sh" \
                --replace "@PYTHONEDA_EXTRA_NAMESPACES@" "org" \
                --replace "@PYTHONPATH@" "$PYTHONPATH" \
                --replace "@CUSTOM_CONTENT@" "" \
                --replace "@PYTHONEDA_SHARED_PYTHONLANG_DOMAIN@" "${pythoneda-shared-pythonlang-domain}" \
                --replace "@PACKAGE@" "$out/lib/python${pythonMajorMinorVersion}/site-packages" \
                --replace "@ENTRYPOINT@" "$out/lib/python${pythonMajorMinorVersion}/site-packages/${package}/application/${entrypoint}.py" \
                --replace "@PYTHON_ARGS@" "" \
                --replace "@BANNER@" "$out/bin/banner.sh"
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist $out/bin
              cp dist/${wheelName} $out/dist
              cp /build/$sourceRoot/entrypoint.sh $out/bin/${entrypoint}.sh
              chmod +x $out/bin/${entrypoint}.sh
              echo '#!/usr/bin/env sh' > $out/bin/banner.sh
              echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/banner.sh
              echo "echo 'Running $out/bin/banner'" >> $out/bin/banner.sh
              echo "pushd $out/lib/python${pythonMajorMinorVersion}/site-packages" >> $out/bin/banner.sh
              echo "${python}/bin/python ${banner_file} \$@" >> $out/bin/banner.sh
              echo "popd" >> $out/bin/banner.sh
              chmod +x $out/bin/banner.sh

              # docker build -t ${org}-${repo}:${version} .
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        apps = rec {
          default = licdata-iac-python311;
          licdata-iac-python38 = shared.app-for {
            package =
              self.packages.${system}.licdata-iac-python38;
            inherit entrypoint;
          };
          licdata-iac-python39 = shared.app-for {
            package =
              self.packages.${system}.licdata-iac-python39;
            inherit entrypoint;
          };
          licdata-iac-python310 = shared.app-for {
            package =
              self.packages.${system}.licdata-iac-python310;
            inherit entrypoint;
          };
          licdata-iac-python311 = shared.app-for {
            package =
              self.packages.${system}.licdata-iac-python311;
            inherit entrypoint;
          };
          licdata-iac-python312 = shared.app-for {
            package =
              self.packages.${system}.licdata-iac-python312;
            inherit entrypoint;
          };
        };
        defaultApp = apps.default;
        defaultPackage = packages.default;
        devShells = rec {
          default = licdata-iac-python311;
          licdata-iac-python38 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-python38}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-python38;
              python = pkgs.python38;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python38;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python38;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-python39 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-python39}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-python310 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-python310}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-python311 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-python311}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-python312 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-python312}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-python312;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              inherit archRole layer org pkgs repo space;
            };
        };
        packages = rec {
          default = licdata-iac-python311;
          licdata-iac-python38 =
            pythoneda-licdata-iac-for {
              licdata = licdata.packages.${system}.licdata-python38;
              python = pkgs.python38;
              pythoneda-iac-events =
                pythoneda-iac-events.packages.${system}.pythoneda-iac-events-python38;
              pythoneda-iac-pulumi-azure =
                pythoneda-iac-pulumi-azure.packages.${system}.pythoneda-iac-pulumi-azure-python38;
              pythoneda-iac-shared =
                pythoneda-iac-shared.packages.${system}.pythoneda-iac-shared-python38;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python38;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python38;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python38;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python38;
            };
          licdata-iac-python39 =
            licdata-iac-for {
              licdata = licdata.packages.${system}.licdata-python39;
              python = pkgs.python39;
              pythoneda-iac-events =
                pythoneda-iac-events.packages.${system}.pythoneda-iac-events-python39;
              pythoneda-iac-pulumi-azure =
                pythoneda-iac-pulumi-azure.packages.${system}.pythoneda-iac-pulumi-azure-python39;
              pythoneda-iac-shared =
                pythoneda-iac-shared.packages.${system}.pythoneda-iac-shared-python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python39;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python39;
            };
          licdata-iac-python310 =
            licdata-iac-for {
              licdata = licdata.packages.${system}.licdata-python310;
              python = pkgs.python310;
              pythoneda-iac-events =
                pythoneda-iac-events.packages.${system}.pythoneda-iac-events-python310;
              pythoneda-iac-pulumi-azure =
                pythoneda-iac-pulumi-azure.packages.${system}.pythoneda-iac-pulumi-azure-python310;
              pythoneda-iac-shared =
                pythoneda-iac-shared.packages.${system}.pythoneda-iac-shared-python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python310;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python310;
            };
          licdata-iac-python311 =
            licdata-iac-for {
              licdata = licdata.packages.${system}.licdata-python311;
              python = pkgs.python311;
              pythoneda-iac-events =
                pythoneda-iac-events.packages.${system}.pythoneda-iac-events-python311;
              pythoneda-iac-pulumi-azure =
                pythoneda-iac-pulumi-azure.packages.${system}.pythoneda-iac-pulumi-azure-python311;
              pythoneda-iac-shared =
                pythoneda-iac-shared.packages.${system}.pythoneda-iac-shared-python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python311;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python311;
            };
          licdata-iac-python312 =
            licdata-iac-for {
              licdata = licdata.packages.${system}.licdata-python312;
              python = pkgs.python312;
              pythoneda-iac-events =
                pythoneda-iac-events.packages.${system}.pythoneda-iac-events-python312;
              pythoneda-iac-pulumi-azure =
                pythoneda-iac-pulumi-azure.packages.${system}.pythoneda-iac-pulumi-azure-python312;
              pythoneda-iac-shared =
                pythoneda-iac-shared.packages.${system}.pythoneda-iac-shared-python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python312;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python312;
            };
        };
      });
}
