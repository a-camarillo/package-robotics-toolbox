{
  description = "Robotics Toolbox for Python";

  inputs = {nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";};

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs) alejandra;
        ansitable = with pkgs.python311Packages;
          buildPythonPackage rec {
            pname = "ansitable";
            version = "0.10.0";
            pyproject = true;
            src = fetchPypi {
              inherit pname version;
              sha256 = "sha256-ehPPpZ9C/Nrly9WoJJfZtv2YfZ9MEcQsKtuxNpcJe7U=";
            };
            propagatedBuildInputs = [
              colored
              setuptools
              setuptools-scm
              wheel
            ];
          };
        spatialmath-python = with pkgs.python311Packages;
          buildPythonPackage rec {
            pname = "spatialmath-python";
            version = "1.1.10";
            pyproject = true;
            src = pkgs.fetchFromGitHub {
              owner = "bdaiinstitute";
              repo = "spatialmath-python";
              rev = "${version}";
              sha256 = "sha256-L85E/ksNtrQpJDrUtr+V26QOfOeqZkdUpsdu4cBGFeE=";
            };
            propagatedBuildInputs = [
              setuptools
              setuptools-scm
              wheel
              oldest-supported-numpy
              scipy
              matplotlib
              pkgs.pre-commit
              pre-commit-hooks
              ansitable
            ];
          };
        spatialgeometry = with pkgs.python311Packages;
          buildPythonPackage rec {
            pname = "spatialgeometry";
            version = "1.1.0";
            pyproject = true;
            src = pkgs.fetchFromGitHub {
              owner = "jhavl";
              repo = "spatialgeometry";
              rev = "v${version}";
              sha256 = "sha256-RvQ0MqvFwqPr5iLIXueijoOsZUpvcgzbrpWhMKN/cV4=";
            };
            doCheck = false;
            propagatedBuildInputs = [
              setuptools
              setuptools-scm
              wheel
              oldest-supported-numpy
              spatialmath-python
            ];
          };
        pgraph = with pkgs.python311Packages;
          buildPythonPackage rec {
            pname = "pgraph";
            version = "0.6.1";
            src = pkgs.fetchFromGitHub {
              owner = "petercorke";
              repo = "pgraph-python";
              rev = "${version}";
              sha256 = "sha256-omuwlFMpT32tt2CsZE2jFU9Jyk9WKW5MsV65lPFv8/A=";
            };
            doCheck = false;
            propagatedBuildInputs = [
              numpy
            ];
          };
        swift-sim = with pkgs.python311Packages;
          buildPythonPackage rec {
            pname = "swift-sim";
            version = "1.1.0";
            pyproject = true;
            src = pkgs.fetchFromGitHub {
              owner = "jhavl";
              repo = "swift";
              rev = "v${version}";
              sha256 = "sha256-9JpBL4sxtWMZ5ztzaGeyGtAbRqH/sR+0tNvUXBmYgzA=";
            };
            propagatedBuildInputs = [
              setuptools
              setuptools-scm
              oldest-supported-numpy
              websockets
              spatialgeometry
            ];
          };
        rtb-data = with pkgs.python311Packages;
          buildPythonPackage rec {
            pname = "rtb-data";
            version = "1.0.1";
            src = fetchPypi {
              inherit pname version;
              sha256 = "sha256-xRKS3c31li5ZRWw6WrYqTVQKXqW91ONbKWP57Dglzx0=";
            };
          };
      in {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              (pkgs.python311.withPackages (ps: [
                (ps.buildPythonPackage rec {
                  pname = "robotics-toolbox-python";
                  version = "1.1.1";
                  format = "pyproject";
                  src = pkgs.fetchurl {
                    url = "https://files.pythonhosted.org/packages/06/ba/c7534df8fb3f04c48862f24f1b4118c0d1e793fdf78e90fe514cbf404e01/roboticstoolbox_python-1.1.1.tar.gz";
                    sha256 = "sha256-JhX4CHhLkZB5J6tA45zC4024mlPnGhS0D5c3VhIuqeQ=";
                  };
                  doCheck = false;
                  propagatedBuildInputs = [
                    ps.setuptools
                    ps.setuptools-scm
                    ps.oldest-supported-numpy
                    ps.matplotlib
                    ps.progress
                    ps.numpy
                    ps.scipy
                    pgraph
                    spatialmath-python
                    spatialgeometry
                    swift-sim
                    ansitable
                    rtb-data
                  ];
                })
              ]))
            ];
          };
        };

        formatter = alejandra;
      };
    };
}
