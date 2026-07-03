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
just# Bitcoin Development Environments

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

* Run electrs (reads RPC credentials from `electrs.toml`)

```bash
just electrum
```

* Run a Bitcoin app using our regtest network (Trezor Suite)

* Start over with a fresh chain (stops bitcoind and deletes the regtest data)

```bash
just reset
```

## Configuration

RPC credentials are fixed (`myuser`/`mypass`) instead of the auto-generated
cookie, so they survive restarts. They are defined in:

* `bitcoin.conf` - bitcoind config, passed via `-conf` by `just start`
* `electrs.toml` - electrs config, passed via `--conf` by `just electrum`
* `Justfile` - used by the `bitcoin-cli` recipes

Both config files live in the repo root (not in the `test/bitcoin` datadir),
so `just reset` never deletes them.

## Thanks!

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

* Run electrs (reads RPC credentials from `electrs.toml`)

```bash
just electrum
```

* Run a Bitcoin app using our regtest network (Trezor Suite)

* Start over with a fresh chain (stops bitcoind and deletes the regtest data)

```bash
just reset
```

## Configuration

RPC credentials are fixed (`myuser`/`mypass`) instead of the auto-generated
cookie, so they survive restarts. They are defined in:

* `bitcoin.conf` - bitcoind config, passed via `-conf` by `just start`
* `electrs.toml` - electrs config, passed via `--conf` by `just electrum`
* `Justfile` - used by the `bitcoin-cli` recipes

Both config files live in the repo root (not in the `test/bitcoin` datadir),
so `just reset` never deletes them.

## Thanks!
