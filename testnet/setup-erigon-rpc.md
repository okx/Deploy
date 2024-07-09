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
git checkout v1.1.5.6 #[checkout the latest release version]

make cdk-erigon
```

#### Config
``` bash
cp xlayerconfig-testnet.yaml.example xlayerconfig-testnet.yaml
```
Modfiy and replace params like this:
``` bash
datadir: /your/data/dir
zkevm.l1-rpc-url:  http://your-l1-rpc-url:8545

zkevm.address-sequencer: "0xD6DdA5AA7749142B7fDa3Fe4662C9f346101B8A6"
zkevm.address-zkevm: "0x01469dACfDDA885D68Ff0f8628F2629c14F95a20"
zkevm.address-admin: "0x14509f825e550745CFF827a9bDCCB4C3ad3FFd36"
zkevm.address-rollup: "0x6662621411A8DACC3cA7049C8BddABaa9a999ce3"
zkevm.address-ger-manager: "0x66E61bA00F58b857A9DD2C500F3aBc424A46BD20"
```
#### Snapshot(Optional)
To quickly restore the Erigon network, you can download the snapshot and extract it.
``` bash
wget https://static.okex.org/cdn/chain/xlayer/snapshot/xlayer-erigon-testnet-snap-202407081247.tar.gz
tar xzvf xlayer-erigon-testnet-snap-202407081247.tar.gz
```
Replace the `datadir` in `xlayerconfig-testnet.yaml` with the path to the extracted snapshot.

#### Start Erigon Node
```
./build/bin/cdk-erigon --config="./xlayerconfig-testnet.yaml"
```