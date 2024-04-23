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
git checkout release/v0.3.1
cp xlayerconfig-testnet.yaml.example xlayerconfig-testnet.yaml
# modify datadir and zkevm.l2-datastreamer-url
make ckd-erigon
./build/bin/cdk-erigon --config="./xlayerconfig-testnet.yaml"
```