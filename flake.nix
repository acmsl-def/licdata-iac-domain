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
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events/0.0.11";
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/24.05";
    pythoneda-shared-iac-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/events/0.0.7";
    };
    pythoneda-shared-iac-pulumi-azure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-iac-events.follows = "pythoneda-shared-iac-events";
      inputs.pythoneda-shared-iac-shared.follows = "pythoneda-shared-iac-shared";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/pulumi-azure/0.0.11";
    };
    pythoneda-shared-iac-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/shared/0.0.7";
    };
    pythoneda-shared-pythonlang-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.71";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.92";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "acmsl";
        repo = "licdata-iac-domain";
        version = "0.0.13";
        sha256 = "1xb8iv6rbc1gi02pck2jhiwl9aqvdl9q6bwisgdzi2d5a6vh8186";
        pname = "${org}-${repo}";
        pythonpackage = "org.acmsl.iac.licdata";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        pkgs = import nixos { inherit system; };
        description = "Licdata IaC";
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
        acmsl-licdata-iac-domain-for = {
          acmsl-licdata-artifact-events, python, pythoneda-shared-iac-events, pythoneda-shared-iac-pulumi-azure, pythoneda-shared-iac-shared, pythoneda-shared-pythonlang-banner
          , pythoneda-shared-pythonlang-domain }:
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
              acmslLicdataArtifactEvents = acmsl-licdata-artifact-events.version;
              pythonedaSharedIacEvents = pythoneda-shared-iac-events.version;
              pythonedaSharedIacPulumiAzure = pythoneda-shared-iac-pulumi-azure.version;
              pythonedaSharedIacShared = pythoneda-shared-iac-shared.version;
              pythonedaSharedPythonlangBanner =
                pythoneda-shared-pythonlang-banner.version;
              pythonedaSharedPythonlangDomain =
                pythoneda-shared-pythonlang-domain.version;
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
              acmsl-licdata-artifact-events
              pulumi
              pulumi-azure-native
              pythoneda-shared-iac-events
              pythoneda-shared-iac-pulumi-azure
              pythoneda-shared-iac-shared
              pythoneda-shared-pythonlang-banner
              pythoneda-shared-pythonlang-domain
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
          default = acmsl-licdata-iac-domain-python311;
          acmsl-licdata-iac-domain-python39 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-domain-python39}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-domain-python39;
              python = pkgs.python39;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python39;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python39;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-domain-python310 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-domain-python310}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-domain-python310;
              python = pkgs.python310;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python310;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python310;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-domain-python311 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-domain-python311}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-domain-python311;
              python = pkgs.python311;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python311;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python311;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-domain-python312 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-domain-python312}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-domain-python312;
              python = pkgs.python312;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python312;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python312;
              inherit archRole layer org pkgs repo space;
            };
          acmsl-licdata-iac-domain-python313 =
            shared.devShell-for {
              banner = "${packages.acmsl-licdata-iac-domain-python313}/bin/banner.sh";
              extra-namespaces = "org";
              nixpkgs-release = nixpkgsRelease;
              package = packages.acmsl-licdata-iac-domain-python313;
              python = pkgs.python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
              inherit archRole layer org pkgs repo space;
            };
        };
        packages = rec {
          default = acmsl-licdata-iac-domain-python311;
          acmsl-licdata-iac-domain-python39 =
            acmsl-licdata-iac-domain-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python39;
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
            };
          acmsl-licdata-iac-domain-python310 =
            acmsl-licdata-iac-domain-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python310;
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
            };
          acmsl-licdata-iac-domain-python311 =
            acmsl-licdata-iac-domain-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python311;
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
            };
          acmsl-licdata-iac-domain-python312 =
            acmsl-licdata-iac-domain-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python312;
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
            };
          acmsl-licdata-iac-domain-python313 =
            acmsl-licdata-iac-domain-for {
              acmsl-licdata-artifact-events = acmsl-licdata-artifact-events.packages.${system}.acmsl-licdata-artifact-events-python313;
              python = pkgs.python313;
              pythoneda-shared-iac-events =
                pythoneda-shared-iac-events.packages.${system}.pythoneda-shared-iac-events-python313;
              pythoneda-shared-iac-pulumi-azure =
                pythoneda-shared-iac-pulumi-azure.packages.${system}.pythoneda-shared-iac-pulumi-azure-python313;
              pythoneda-shared-iac-shared =
                pythoneda-shared-iac-shared.packages.${system}.pythoneda-shared-iac-shared-python313;
              pythoneda-shared-pythonlang-banner =
                pythoneda-shared-pythonlang-banner.packages.${system}.pythoneda-shared-pythonlang-banner-python313;
              pythoneda-shared-pythonlang-domain =
                pythoneda-shared-pythonlang-domain.packages.${system}.pythoneda-shared-pythonlang-domain-python313;
            };
        };
      });
}
