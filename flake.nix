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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:acmsl-def/licdata-artifact-events/0.0.22";
    };
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    pythoneda-shared-iac-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/events/0.0.21";
    };
    pythoneda-shared-iac-pulumi-azure = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-iac-events.follows = "pythoneda-shared-iac-events";
      inputs.pythoneda-shared-iac-shared.follows = "pythoneda-shared-iac-shared";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/pulumi-azure/0.0.24";
    };
    pythoneda-shared-iac-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-iac-def/shared/0.0.18";
    };
    pythoneda-shared-pythonlang-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:pythoneda-shared-pythonlang-def/banner/0.0.74";
    };
    pythoneda-shared-pythonlang-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      url = "github:pythoneda-shared-pythonlang-def/domain/0.0.110";
    };
    pythoneda-shared-runtime-secrets-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pythoneda-shared-pythonlang-banner.follows =
        "pythoneda-shared-pythonlang-banner";
      inputs.pythoneda-shared-pythonlang-domain.follows =
        "pythoneda-shared-pythonlang-domain";
      url = "github:pythoneda-shared-runtime-def/secrets-events/0.0.11";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "acmsl";
        repo = "licdata-iac-domain";
        version = "0.0.26";
        sha256 = "1dv1s0lsdlw2xaisppg6kj0r6grdb9r6b0yl5wc095a9yk4s9gz9";
        pname = "${org}-${repo}";
        pythonpackage = "org.acmsl.iac.licdata";
        package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
        pkgs = import nixpkgs { inherit system; };
        description = "Licdata IaC";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "I";
        layer = "A";
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import "${pythoneda-shared-pythonlang-banner}/nix/shared.nix";
        acmsl-licdata-iac-domain-for = {
          acmsl-licdata-artifact-events
          , python
          , pythoneda-shared-iac-events
          , pythoneda-shared-iac-pulumi-azure
          , pythoneda-shared-iac-shared
          , pythoneda-shared-pythonlang-banner
          , pythoneda-shared-pythonlang-domain
          , pythoneda-shared-runtime-secrets-events }:
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
              inherit homepage pname pythonMajorMinorVersion package
                version;
              acmslLicdataArtifactEvents = acmsl-licdata-artifact-events.version;
              pythonedaSharedIacEvents = pythoneda-shared-iac-events.version;
              pythonedaSharedIacPulumiAzure = pythoneda-shared-iac-pulumi-azure.version;
              pythonedaSharedIacShared = pythoneda-shared-iac-shared.version;
              pythonedaSharedPythonlangBanner =
                pythoneda-shared-pythonlang-banner.version;
              pythonedaSharedPythonlangDomain =
                pythoneda-shared-pythonlang-domain.version;
              pythonedaSharedRuntimeSecretsEvents =
                pythoneda-shared-runtime-secrets-events.version;
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
              pythoneda-shared-runtime-secrets-events
            ];

            # pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              command cp -r ${src} .
              sourceRoot=$(command ls | command grep -v env-vars)
              command chmod -R +w $sourceRoot
              command cp ${pyprojectToml} $sourceRoot/pyproject.toml
            '';

            postInstall = with python.pkgs; ''
              command pushd /build/$sourceRoot
              for f in $(command find . -name '__init__.py'); do
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  command cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f;
                fi
              done
              command popd
              command mkdir -p $out/dist $out/deps/flakes $out/deps/nixpkgs
              command cp dist/${wheelName} $out/dist
              for dep in ${acmsl-licdata-artifact-events} ${pythoneda-shared-iac-events} ${pythoneda-shared-iac-pulumi-azure} ${pythoneda-shared-iac-shared} ${pythoneda-shared-pythonlang-banner} ${pythoneda-shared-pythonlang-domain} ${pythoneda-shared-runtime-secrets-events}; do
                command cp -r $dep/dist/* $out/deps || true
                if [ -e $dep/deps ]; then
                  command cp -r $dep/deps/* $out/deps || true
                fi
                METADATA=$dep/lib/python${pythonMajorMinorVersion}/site-packages/*.dist-info/METADATA
                NAME="$(command grep -m 1 '^Name: ' $METADATA | command cut -d ' ' -f 2)"
                VERSION="$(command grep -m 1 '^Version: ' $METADATA | command cut -d ' ' -f 2)"
                command ln -s $dep $out/deps/flakes/$NAME-$VERSION || true
              done
              for nixpkgsDep in ${pulumi} ${pulumi-azure-native}; do
                METADATA=$nixpkgsDep/lib/python${pythonMajorMinorVersion}/site-packages/*.dist-info/METADATA
                NAME="$(command grep -m 1 '^Name: ' $METADATA | command cut -d ' ' -f 2)"
                VERSION="$(command grep -m 1 '^Version: ' $METADATA | command cut -d ' ' -f 2)"
                command ln -s $nixpkgsDep $out/deps/nixpkgs/$NAME-$VERSION || true
              done
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
              pythoneda-shared-runtime-secrets-events =
                pythoneda-shared-runtime-secrets-events.packages.${system}.pythoneda-shared-runtime-secrets-events-python39;
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
              pythoneda-shared-runtime-secrets-events =
                pythoneda-shared-runtime-secrets-events.packages.${system}.pythoneda-shared-runtime-secrets-events-python310;
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
              pythoneda-shared-runtime-secrets-events =
                pythoneda-shared-runtime-secrets-events.packages.${system}.pythoneda-shared-runtime-secrets-events-python311;
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
              pythoneda-shared-runtime-secrets-events =
                pythoneda-shared-runtime-secrets-events.packages.${system}.pythoneda-shared-runtime-secrets-events-python312;
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
              pythoneda-shared-runtime-secrets-events =
                pythoneda-shared-runtime-secrets-events.packages.${system}.pythoneda-shared-runtime-secrets-events-python313;
            };
        };
      });
}
