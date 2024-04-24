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
cp xlayerconfig-mainnet.yaml.example xlayerconfig-mainnet.yaml
# vim xlayerconfig-mainnet.yaml,  and modify datadir and zkevm.l2-datastreamer-url
make cdk-erigon
./build/bin/cdk-erigon --config="./xlayerconfig-mainnet.yaml"
```