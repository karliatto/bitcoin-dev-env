# Bitcoin Development Environments

## Introduction

Today we'll explore Bitcoin development environment.
- What do we mean by Bitcoin dev envs?
- Why we need Bitcoin development env?
- What type of Bitcoin development env do we have?
- How to do it? (demo time)


## What do we mean by Bitcoin dev envs?

It could mean different things depending on what you do.
- It could be you are Bitcoin core dev and need C, python ...
- It could be you are developing a lightning app so you need LND CLightning ...
- It could be you want to develop on top of Bitcoin protocol base layer so you need Bitcoind

The last one is the one we are going to be talking here

## Why we need Bitcoin development env?

- Similar to real world environment
- Repeatability (getting the same results when the same team uses the same experimental setup)
- Usable for automated tests, CI ...

## What type of Bitcoin development env do we have?

- mainnet
- testnet 1, 2, 3, 4 ...
- signet
- regtest

## Mainnet

- Where you store your savings
- Expensive to use
- Not good properties for develoment environment


## Testnet

Testnet is a great place to try out new things without risking real money, but it is notoriously unreliable. Huge block reorgs, long gaps in between blocks being mined or sudden bursts of blocks in rapid succession mean that realistic testing of software, especially involving multiple independent parties running software over an extended period of time, becomes infeasible in practice.
- Good for testing when it involves other people
- Good is not real money
- Not Good for replicability

## Signet (BIP 325)

Signatures are used in addition to proof of work for block progress, enabling much better coordination and robustness (be reliably unreliable), for persistent, longer-term testing scenarios involving multiple independent parties."
- Good for testing when it involves other people"
- Not Good for replicability
- https://github.com/bitcoin/bitcoin/pull/18267"
- https://github.com/bitcoin/bips/blob/master/bip-0325.mediawiki"
- https://mempool.space/signet"

### Vanilla Signet

- Signet was merged into Bitcoin Core in PR 18267 in September - 2020 and was first included in the 0.21 release.

Signet flag to run a Signet node:

```bash
bitcoind -signet
```

To create a Signet wallet:

```bash
bitcoin-cli -signet createwallet "insert_wallet_name"
```

### Custom Signet

- https://github.com/bitcoin/bitcoin/blob/master/contrib/signet/README.md


## Regtest

Regtest is a bitcoin network we start from scratch and create the state we need. Perfecto to create and test Bitcoin applications in a controlled setting.
	- Good for replicability
	- No real money

### Demo time

Let's create a Bitcoin regtest network and use it for testing real world Bitcoin app.

#### Requirements

* Nix - https://nixos.org/download/
* Enable flakes in nix config - ~/.config/nix/nix.conf
```
experimental-features = nix-command flakes
```

#### Steps

* Use `flake.nix` in this repo by running the command:

```bash
nix develop
```

* Create a wallet

```bash
createwallet "test"
```

* Generate a block

```bash
genblocks
```

* Get blockchain info

```bash
bcli getblockchaininfo
```

* After mining do you have any funds?

```bash
bcli getbalance
```

* Run electrs 

```bash
electrs --network regtest --log-filters info --daemon-dir /home/user/proyectos/bitcoin-dev-env/test/bitcoin/ --electrum-rpc-addr="0.0.0.0:50001"
```

* Run a Bitcoin app using our regtest network (Trezor Suite)

## Thanks!
