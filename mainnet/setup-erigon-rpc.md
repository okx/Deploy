# Setup production erigon
cdk-erigon is a fork of Erigon, optimized for syncing with the XLayer network.

### Minimum System Requirements
- 16 GB RAM
- 8 core CPU
- 500 GB Storage (This will increase over time) 

### Start Erigon RPC Node

#### Build
``` bash
git clone https://github.com/0xPolygonHermez/cdk-erigon.git
cd cdk-erigon
git checkout v1.1.5.8 #[checkout the latest release version]

make cdk-erigon
```

#### Config
``` bash
cp xlayerconfig-mainnet.yaml.example xlayerconfig-mainnet.yaml
```
Modfiy and replace params like this:
``` bash
datadir: /your/data/dir
zkevm.l1-rpc-url:  http://your-l1-rpc-url:8545

zkevm.address-sequencer: "0xAF9d27ffe4d51eD54AC8eEc78f2785D7E11E5ab1"
zkevm.address-zkevm: "0x2B0ee28D4D51bC9aDde5E58E295873F61F4a0507"
zkevm.address-admin: "0x491619874b866c3cDB7C8553877da223525ead01"
zkevm.address-rollup: "0x5132A183E9F3CB7C848b0AAC5Ae0c4f0491B7aB2"
zkevm.address-ger-manager: "0x580bda1e7A0CFAe92Fa7F6c20A3794F169CE3CFb"
```
#### Snapshot(Optional)
The latest snapshot file can be found [here](https://static.okex.org/cdn/chain/xlayer/snapshot/erigon-mainnet-snapshot.json)
To quickly restore the Erigon network, you can download the snapshot and extract it.
``` bash
wget https://static.okex.org/cdn/chain/xlayer/snapshot/xlayer-erigon-mainnet-snap-202408140200.tar.gz
tar xzvf xlayer-erigon-mainnet-snap-202408140200.tar.gz
```
Replace the `datadir` in `xlayerconfig-mainnet.yaml` with the path to the extracted snapshot.

#### Start Erigon Node
```
./build/bin/cdk-erigon --config="./xlayerconfig-mainnet.yaml"
```
