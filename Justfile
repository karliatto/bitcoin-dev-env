set quiet := true
msrv := "1.75.0"
default_wallet := 'regtest_default_wallet'
datadir := justfile_directory() + "/test/bitcoin"
rpc_host := "127.0.0.1"
rpc_port := "18443"
cookie := datadir + "/regtest/.cookie"
electrs_db := env_var('HOME') + "/db/regtest"

# escrow wallet
escrow_wallet := 'escrow_wallet'

bcli := "bitcoin-cli -regtest --rpcconnect=" + rpc_host + " --rpcport=" + rpc_port + " --rpccookiefile=" + cookie

# list of recipes
default:
  just --list

# start regtest bitcoind
[group('rpc')]
start:
    mkdir -p "{{datadir}}"
    bitcoind -regtest -datadir={{datadir}} -server=1 -txindex=1 -fallbackfee=0.0002 -minimumchainwork=0

# stop regtest bitcoind
[group('rpc')]
stop:
    pkill bitcoind

# stop and delete regtest bitcoind data
[group('rpc')]
reset: stop
    rm -rf {{datadir}}

# start electrs indexer
[group('rpc')]
electrum:
    electrs --log-filters INFO --db-dir={{electrs_db}} --electrum-rpc-addr=0.0.0.0:50001 --daemon-rpc-addr=0.0.0.0:{{rpc_port}} --network=regtest --cookie-file={{cookie}}

# get blockchain info
[group('rpc')]
info:
    {{bcli}} getblockchaininfo

# get current block height
[group('rpc')]
getheight:
    {{bcli}} getblockcount

# generate n new blocks to given address
[group('rpc')]
generate n address:
    {{bcli}} generatetoaddress {{n}} {{address}}

# generate n blocks (mines to new address in default wallet)
[group('rpc')]
genblocks n="1" wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} -generate {{n}}

# list regtest wallets
[group('rpc')]
list:
    {{bcli}} listwallets

# create regtest wallet
[group('rpc-default')]
create wallet=default_wallet:
    {{bcli}} createwallet {{wallet}}

# load regtest wallet
[group('rpc-default')]
load wallet=default_wallet:
    {{bcli}} loadwallet {{wallet}}

# unload regtest wallet
[group('rpc-default')]
unload wallet=default_wallet:
    {{bcli}} unloadwallet {{wallet}}

# get regtest wallet address
[group('rpc-default')]
address wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} getnewaddress

# get regtest wallet balance
[group('rpc-default')]
balance wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} getbalance

# send n btc to address from wallet
[group('rpc-default')]
send n address wallet=default_wallet:
    {{bcli}} -named -rpcwallet={{wallet}} sendtoaddress address={{address}} amount={{n}}

# list wallet descriptors info, private = (true | false)
[group('rpc-default')]
descriptors private wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} listdescriptors {{private}}

# run any bitcoin-cli rpc command with default wallet
[group('rpc-default')]
rpc command wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} {{command}}

# broadcast a raw transaction
[group('rpc-default')]
escrow_broadcast tx_hex wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} sendrawtransaction {{tx_hex}}

# list unspent utxos in escrow wallet
[group('rpc-default')]
escrow_utxos wallet=default_wallet:
    {{bcli}} -rpcwallet={{wallet}} listunspent
