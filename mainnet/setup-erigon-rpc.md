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

zkevm.address-sequencer: "0x148Ee7dAF16574cD020aFa34CC658f8F3fbd2800"
zkevm.address-zkevm: "0x519E42c24163192Dca44CD3fBDCEBF6be9130987"
zkevm.address-admin: "0x242daE44F5d8fb54B198D03a94dA45B5a4413e21"
zkevm.address-rollup: "0x5132A183E9F3CB7C848b0AAC5Ae0c4f0491B7aB2"
zkevm.address-ger-manager: "0x580bda1e7A0CFAe92Fa7F6c20A3794F169CE3CFb"
```
#### Snapshot(Optional)
To quickly restore the Erigon network, you can download the snapshot and extract it.
``` bash
wget https://static.okex.org/cdn/chain/xlayer/snapshot/xlayer-erigon-mainnet-snap-202407161055.tar.gz
tar xzvf xlayer-erigon-mainnet-snap-202407161055.tar.gz
```
Replace the `datadir` in `xlayerconfig-mainnet.yaml` with the path to the extracted snapshot.

#### Start Erigon Node
```
./build/bin/cdk-erigon --config="./xlayerconfig-mainnet.yaml"
```