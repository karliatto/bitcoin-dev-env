{
	description = "bitcoin development environment";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-24.11";
		nixpkgs-master.url = "github:NixOS/nixpkgs/master";
		flake-utils = {
			url = "github:numtide/flake-utils";
		};
		rust-overlay = {
			url = "github:oxalica/rust-overlay";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, nixpkgs-master, flake-utils, rust-overlay }:
		flake-utils.lib.eachDefaultSystem (system:
			let
				bitcoinVersion = "29.0";
				rustVersion = "1.75.0";

				lib = nixpkgs.lib;
				isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
				target = lib.strings.replaceStrings [ "-" ] [ "_" ] pkgs.stdenv.buildPlatform.config;
				overlays = [ rust-overlay.overlays.default ];
				pkgs = import nixpkgs {
					inherit system overlays;
				};

				masterPkgs = import nixpkgs-master {
					inherit system;
				};

				rust = pkgs.rust-bin.stable.${rustVersion}.default.override {
					extensions = [ "rust-src" "rust-analyzer" ];
				};

				bitcoin = masterPkgs.bitcoind.overrideAttrs (old: {
					version = bitcoinVersion;
					src = pkgs.fetchurl {
						urls = [ "https://bitcoincore.org/bin/bitcoin-core-${bitcoinVersion}/bitcoin-${bitcoinVersion}.tar.gz" ];
						sha256 = "sha256-iCx4LDSjvy6s0frlzcWLNbhpiDUS8Zf31tyPGV3s/ao=";
					};
					doCheck = false;
				});

				hal = pkgs.rustPlatform.buildRustPackage rec {
					pname = "hal";
					version = "0.9.5";
					src = pkgs.fetchCrate {
						inherit pname version;
						sha256 = "sha256-rwVny9i0vFycoeAesy2iP7sA16fECLu1UPbqrOJa1is=";
					};
					cargoSha256 = "sha256-dATviea1btnIVYKKgU1fMtZxKJitp/wXAuoIsxCSgf4=";
				};

				electrs = pkgs.electrs;
			in
			{
				devShells.default = pkgs.mkShell {
					nativeBuildInput = [ ];
					buildInputs = [
						pkgs.git
						hal
						rust
						pkgs.jq
						bitcoin
						electrs

						# development tools
						pkgs.just
					];

					shellHook = ''
						echo "-------------------------------------------"
						echo "Welcome to the Bitcoin Development Environment"
						echo "-------------------------------------------"
						echo "Run \`just\` to see the available commands."
					'';
				};
			}
		);
}

