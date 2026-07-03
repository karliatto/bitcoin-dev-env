# Bitcoin Development Environments

## Requirements

* Nix - https://nixos.org/download/
* Enable flakes in nix config - ~/.config/nix/nix.conf
```
experimental-features = nix-command flakes
```

## How to use

* Use `flake.nix` in this repo by running the command:

```bash
nix develop
```

* List all available commands

```bash
just
```

* Start the regtest bitcoind (uses `bitcoin.conf` from the repo root)

```bash
just start
```

* Create the default wallet

```bash
just create
```

* Generate blocks (101 so the first coinbase matures and is spendable)

```bash
just genblocks 101
```

* Get blockchain info

```bash
just info
```

* After mining do you have any funds?

```bash
just balance
```

* Run any other bitcoin-cli RPC command against the default wallet

```bash
just rpc getblockchaininfo
```

* Run electrs

```bash
just electrum
```

* Run a Bitcoin app using our regtest network (Trezor Suite)

* Start over with a fresh chain (stops bitcoind and deletes the regtest data)

```bash
just reset
```

## Configuration

bitcoind can run with either of two RPC auth modes:

* `just start` - fixed credentials (`myuser`/`mypass`), stable across restarts.
  Useful when other apps connect to the node and you don't want to update
  their config after every restart.
* `just start-cookie` - cookie auth: bitcoind writes a fresh random credential
  to `test/bitcoin/regtest/.cookie` on every start and deletes it on shutdown.

All the client recipes (`bcli`-based commands and `just electrum`) detect the
mode automatically: if the cookie file exists they use it, otherwise they fall
back to the fixed credentials.

Config files:

* `bitcoin.conf` - bitcoind config, passed via `-conf` by both start recipes
* `electrs.toml` - electrs credentials for fixed-auth mode, passed via `--conf`
* `Justfile` - connection details and fixed credentials for the CLI recipes

Both config files live in the repo root (not in the `test/bitcoin` datadir),
so `just reset` never deletes them.
