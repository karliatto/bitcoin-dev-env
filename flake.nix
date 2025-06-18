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
					];

					shellHook = ''
						BITCOIN_DATADIR=$PWD/test/bitcoin
						BITCOIN_CLI=bitcoin-cli
						BITCOIND=bitcoind

						BITCOIND_RPC_PORT=18443
						BITCOIND_RPC_HOST=127.0.0.1
						BITCOIND_URL=http://$BITCOIND_RPC_HOST:$BITCOIND_RPC_PORT
						BITCOIND_COOKIE=$BITCOIN_DATADIR/regtest/.cookie

						# Define a function to print the startup message
						printStartupMessage() {
							echo "-------------------------------------------"
							echo "Welcome to the Bitcoin Development Environment"
							echo "-------------------------------------------"
							echo "Available commands:"
							echo "- \`bstart\`: Start the Bitcoin regtest"
							echo "- \`bcli\`: Use the Bitcoin CLI"
							echo "- \`listwallets\`: Get the list of wallets created"
							echo "- \`createwallet\`: Create regtest wallet (createwallet "testwallet")"
							echo "- \`genblocks\`: Generate blocks in regtest"
							echo "- \`setmineaddr\`: Set the mining address"
							echo "- \`getheight\`: Get the current block height"
							echo "- \`gethelp\`: Get help for commands in this dev env"
							echo "-------------------------------------------"
						}

						# Define aliases
						alias bcli="$BITCOIN_CLI -regtest --rpcconnect=$BITCOIND_RPC_HOST --rpcport=$BITCOIND_RPC_PORT --rpccookiefile=$BITCOIND_COOKIE"
						alias bstart="$BITCOIND -regtest -datadir=$BITCOIN_DATADIR -server=1 -txindex=1 -fallbackfee=0.0002"
						alias listwallets="bcli listwallets"
						alias createwallet="bcli createwallet"
						alias genblocks="bcli -generate"
						alias setmineaddr="bcli setgenerate true"
						alias getheight="bcli getblockcount"
						alias gethelp="printStartupMessage"

						# Create the BITCOIN_DATADIR if it does not exist
						mkdir -p "$BITCOIN_DATADIR"

						printStartupMessage
					'';
				};
			}
		);
}

