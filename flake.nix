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
      url = "github:acmsl-def/licdata-artifact-events/0.0.7";
    };
    acmsl-licdata-artifact-events-infrastructure = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.acmsl-licdata-artifact-events.follows = "acmsl-licdata-artifact-events";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events-infrastructure/0.0.7";
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    acmsl-licdata = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:acmsl-def/licdata-def/0.0.10";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      inputs.pythoneda-shared-pythonlang-infrastructure.follows =
        "pythoneda-shared-pythonlang-infrastructure";
      inputs.pythoneda-shared-pythonlang-application.follows =
        "pythoneda-shared-pythonlang-application";
    };
    pythoneda-shared-iac-events = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/events/0.0.7";
    };
    pythoneda-shared-iac-pulumi-azure = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-iac-events.follows = "pythoneda-shared-iac-events";
      inputs.pythoneda-shared-iac-shared.follows = "pythoneda-shared-iac-shared";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/pulumi-azure/0.0.8";
    };
    pythoneda-shared-iac-shared = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/shared/0.0.7";
    };
    pythoneda-shared-pythonlang-banner = {
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.70";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.89";
    };
    pythoneda-shared-pythonlang-infrastructure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-pythonlang-def/infrastructure/0.0.65";
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
      url = "github:pythoneda-shared-pythonlang-def/application/0.0.86";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "acmsl";
        repo = "licdata-iac";
        version = "0.0.8";
        sha256 = "014i8dmg2wfld81rki5jaw2zxysfwx4if2v9rxwfh8r06rqz71z1";
        pname = "${org}-${repo}";
        pythonpackage = "org.acmsl.iac.licdata";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        pkgs = import nixos { inherit system; };
        description = "Licdata IaC";
        entrypoint = "licdata_iac_app";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "I";
        layer = "A";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        licdata-iac-domain-for = {
          licdata, python, pythoneda-shared-iac-events, pythoneda-shared-iac-pulumi-azure, pythoneda-shared-iac-shared, pythoneda-shared-pythonlang-banner
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
              pythonedaSharedIacEvents = pythoneda-shared-iac-events.version;
              pythonedaSharedIacPulumiAzure = pythoneda-shared-iac-pulumi-azure.version;
              pythonedaSharedIacShared = pythoneda-shared-iac-shared.version;
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

            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = [ python.pkgs.pip python.pkgs.poetry-core pkgs.docker ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-shared-iac-events
              pythoneda-shared-iac-pulumi-azure
              pythoneda-shared-iac-shared
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
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              popd
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = licdata-iac-domain-python311;
          licdata-iac-domain-python38 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-domain-python38}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-domain-python38;
              python = pkgs.python38;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python38;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python38;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-domain-python39 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-domain-python39}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-domain-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-domain-python310 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-domain-python310}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-domain-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-domain-python311 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-domain-python311}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-domain-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              inherit archRole layer org pkgs repo space;
            };
          licdata-iac-domain-python312 =
            shared.devShell-for {
              banner = "${packages.licdata-iac-domain-python312}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.licdata-iac-domain-python312;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              inherit archRole layer org pkgs repo space;
            };
        };
        packages = rec {
          default = licdata-iac-domain-python311;
          licdata-iac-domain-python38 =
            pythoneda-licdata-iac-domain-for {
              licdata = licdata.packages.${system}.licdata-python38;
              python = pkgs.python38;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python38;
              pythoneda-shared-iac-pulumi-azure =
                pythoneda-shared-iac-pulumi-azure.packages.${system}.pythoneda-shared-iac-pulumi-azure-python38;
              pythoneda-shared-iac-shared =
                pythoneda-shared-iac-shared.packages.${system}.pythoneda-shared-iac-shared-python38;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python38;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python38;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python38;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python38;
            };
          licdata-iac-domain-python39 =
            licdata-iac-domain-for {
              licdata = licdata.packages.${system}.licdata-python39;
              python = pkgs.python39;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python39;
              pythoneda-shared-iac-pulumi-azure =
                pythoneda-shared-iac-pulumi-azure.packages.${system}.pythoneda-shared-iac-pulumi-azure-python39;
              pythoneda-shared-iac-shared =
                pythoneda-shared-iac-shared.packages.${system}.pythoneda-shared-iac-shared-python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python39;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python39;
            };
          licdata-iac-domain-python310 =
            licdata-iac-domain-for {
              licdata = licdata.packages.${system}.licdata-python310;
              python = pkgs.python310;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python310;
              pythoneda-shared-iac-pulumi-azure =
                pythoneda-shared-iac-pulumi-azure.packages.${system}.pythoneda-shared-iac-pulumi-azure-python310;
              pythoneda-shared-iac-shared =
                pythoneda-shared-iac-shared.packages.${system}.pythoneda-shared-iac-shared-python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python310;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python310;
            };
          licdata-iac-domain-python311 =
            licdata-iac-domain-for {
              licdata = licdata.packages.${system}.licdata-python311;
              python = pkgs.python311;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python311;
              pythoneda-shared-iac-pulumi-azure =
                pythoneda-shared-iac-pulumi-azure.packages.${system}.pythoneda-shared-iac-pulumi-azure-python311;
              pythoneda-shared-iac-shared =
                pythoneda-shared-iac-shared.packages.${system}.pythoneda-shared-iac-shared-python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              pythoneda-shared-pythonlang-infrastructure =
                pythoneda-shared-pythonlang-infrastructure.packages.${system}.pythoneda-shared-pythonlang-infrastructure-python311;
              pythoneda-shared-pythonlang-application =
                pythoneda-shared-pythonlang-application.packages.${system}.pythoneda-shared-pythonlang-application-python311;
            };
          licdata-iac-domain-python312 =
            licdata-iac-domain-for {
              licdata = licdata.packages.${system}.licdata-python312;
              python = pkgs.python312;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python312;
              pythoneda-shared-iac-pulumi-azure =
                pythoneda-shared-iac-pulumi-azure.packages.${system}.pythoneda-shared-iac-pulumi-azure-python312;
              pythoneda-shared-iac-shared =
                pythoneda-shared-iac-shared.packages.${system}.pythoneda-shared-iac-shared-python312;
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
