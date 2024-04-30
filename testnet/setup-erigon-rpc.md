# Setup production erigon
cdk-erigon is a fork of Erigon, optimized for syncing with the XLayer network.

### Minimum System Requirements
- 16 GB RAM
- 8 core CPU
- 500 GB Storage (This will increase over time) 

### Network Components
``` bash
git clone https://github.com/okx/xlayer-erigon
cd xlayer-erigon
# git checkout [the latest release version]
cp xlayerconfig-testnet.yaml.example xlayerconfig-testnet.yaml
# vim xlayerconfig-testnet.yaml,  and modify datadir and zkevm.l1-rpc-url
make cdk-erigon
./build/bin/cdk-erigon --config="./xlayerconfig-testnet.yaml"
```