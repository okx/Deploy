# Setup production erigon

cdk-erigon is a fork of Erigon, optimized for syncing with the XLayer network.



### Minimum System Requirements

- 16 GB RAM

- 8 core CPU

- 500 GB Storage (This will increase over time)



### Start Erigon RPC Node



#### Preparation

***Important: A Golang environment with version 1.24 or above is required.***



#### Build

```bash
# Pull the code from GitHub
git clone https://github.com/okx/xlayer-erigon.git

# Enter the cdk-erigon directory
cd cdk-erigon

# Switch to a tag
git checkout ${latest_release} # [Switch to the corresponding branch as needed]

# Build the project. This process takes about 1 minute. After completion, the binary file will be located in the build/bin directory of the project, and the binary file name is: cdk-erigon.
make cdk-erigon

#If you want to generate an image, you can use the following methods：
make build-docker

```



#### Config

```bash
# After the binary compilation is successful, start modifying the configuration files. 
# xlayerconfig-mainnet.yaml.example  This file is used to connect to the Ethereum mainnet.
# Choose to use the mainnet configuration, and rename the file as follows:

cp xlayerconfig-mainnet.yaml.example xlayerconfig-mainnet.yaml
```



#### Modfiy Config:

```bash
# The following configuration items in xlayerconfig-mainnet.yaml need to be modified:

# XLayer data storage directory, defined by yourself.
datadir: ${your-data-dir}

chain: xlayer-mainnet
http: true
private.api.addr: localhost:9091
zkevm.l2-chain-id: 196
zkevm.l2-sequencer-rpc-url: https://rpc.xlayer.tech
zkevm.l2-datastreamer-url: stream.xlayer.tech:8800
# Layer1 mainnet RPC address. For personal temporary testing, you can apply for it on related websites such as ankr. Note: This is only for personal testing. In a production environment, you need to apply to the company for an official RPC.
zkevm.l1-rpc-url: ${your-l1-rpc-url}
zkevm.l1-chain-id: 1

zkevm.address-sequencer: "0xAF9d27ffe4d51eD54AC8eEc78f2785D7E11E5ab1"
zkevm.address-zkevm: "0x2B0ee28D4D51bC9aDde5E58E295873F61F4a0507"
zkevm.address-rollup: "0x5132A183E9F3CB7C848b0AAC5Ae0c4f0491B7aB2"
zkevm.address-ger-manager: "0x580bda1e7A0CFAe92Fa7F6c20A3794F169CE3CFb"

zkevm.l1-rollup-id: 3
zkevm.l1-first-block: 19218658
zkevm.l1-block-range: 2000
zkevm.l1-query-delay: 1000
zkevm.datastream-version: 3

http.api: [eth, debug, net, trace, web3, erigon, zkevm]
http.addr: 0.0.0.0
http.port: 8545
```



#### Start Erigon Node By binary

```bash
# Start the node. ./build/bin/cdk-erigon is the directory where the user's binary file is located, and --config="the directory of the configuration file to be used".
./build/bin/cdk-erigon --config="./xlayerconfig-mainnet.yaml"


# If you see the following content in your log, the startup is successful：

INFO[07-26|10:25:05.503] Mapped network port                      proto=udp extport=30304 intport=30304 interface="UPNP IGDv1-IP1"
INFO[07-26|10:25:13.963] [1/16 L1Syncer] L1 Blocks processed progress (amounts): 64000/3358713 (1%) 
INFO[07-26|10:25:23.963] [1/16 L1Syncer] L1 Blocks processed progress (amounts): 140000/3358713 (4%) 
INFO[07-26|10:25:33.960] [1/16 L1Syncer] L1 Blocks processed progress (amounts): 222000/3358713 (6%) 
```

