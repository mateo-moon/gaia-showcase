#!/usr/bin/env sh

#Check if node is already initialized
if [ -d $HOME/.gaia ]; then
  echo "Node is already initialized"
  exit 0
fi

#Init node
gaiad init --chain-id ${CHAIN_ID} ${MONIKER}
gaiad tendermint unsafe-reset-all --home $HOME/.gaia

#Download genesis
wget -O $HOME/.gaia/config/genesis.json ${GENESIS_URL}

#Set minimum-gas-prices and persistent_peers
sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.025uatom"/' $HOME/.gaia/config/app.toml
PERSISTENT_PEERS=${PERSISTENT_PEERS:-$(curl -s https://raw.githubusercontent.com/cosmos/chain-registry/master/cosmoshub/chain.json | jq -r '[foreach .peers.seeds[] as $item (""; "\($item.id)@\($item.address)")] | join(",")')}
sed -i'' "s/persistent_peers = \"\"/persistent_peers = \"${PERSISTENT_PEERS:-}\"/" $HOME/.gaia/config/config.toml

#Download pruned state
URL=`curl -L https://quicksync.io/cosmos.json|jq -r '.[] |select(.file=="cosmoshub-4-pruned")|.url'`
cd $HOME/.gaia
aria2c -x5 $URL
lz4 -c -d --rm `basename $URL` | tar xf -

#Download addressbook
curl -L https://quicksync.io/addrbook.cosmos.json > $HOME/.gaia/config/addrbook.json
