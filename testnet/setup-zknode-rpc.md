# Setup testnet zkNode
Re-download the script and snapshot will take about 3 hours.
``` bash
# Quick Commands
apt install axel  # Parallel download tools
apt install pigz  # Parallel compression tools
wget https://static.okex.org/cdn/chain/xlayer/snapshot/run_xlayer_testnet.sh && chmod +x run_xlayer_testnet.sh && ./run_xlayer_testnet.sh init && cp ./testnet/example.env ./testnet/.env
vim ./testnet/.env # Modify XLAYER_NODE_ETHERMAN_URL = "http://your.L1node.url"
./run_xlayer_testnet.sh restore 
./run_xlayer_testnet.sh start
```

X Layer is now available on the Testnet for developers to launch smart contracts, execute transactions, and experiment with the network. This tutorial extends the exploration by allowing developers to launch their own node on the Public network.
Before we begin, this document is fairly technical and requires prior exposure to Docker and CLI. Post spinning up your zkNode instance, you will be able to run the Synchronizer and utilize the JSON-RPC interface.

## Prerequisites
This tutorial assumes that you have docker-compose already installed. If you need any help with the installation, please check the [official docker-compose installation guide](https://docs.docker.com/compose/install/).

### Minimum System Requirements
zkProver does not work on ARM-based Macs yet, and using WSL/WSL2 on Windows is not advisable. Currently, zkProver optimizations require CPUs that support the AVX2 instruction, which means some non-M1 computers, such as AMD, won't work with the software regardless of the OS.


- 16 GB RAM
- 8 core CPU
- 2 TB Storage (This will increase over time) 

### Network Components
Here is a list of crucial network components that are required before you can run the zkNode:
- Ethereum Node - Use geth or any service providing a JSON RPC interface for accessing the L1 network
- X Layer-Node (or zkNode)  - L2 Network
  - Synchronizer - Responsible for synchronizing data between L1 and L2
  - JSON RPC Server - Interface to L2 network 
  - State DB - Save the L2 account, block and tx data.

Let's set up each of the above components!

## Ethereum Node Setup
The Ethereum RPC Node is the first component to be deployed because zkNode needs to synchronize blocks and transactions on L1. You can invoke the ETH RPC Sepolia service through any of the following methods:
- Third-party RPC services, such as [Infura](https://www.infura.io/) or [Ankr](https://www.ankr.com/).
- Set up your own Ethereum node. Follow the instructions provided in this [guide to set up and install Geth](https://geth.ethereum.org/docs/getting-started/installing-geth).

## Installing
Once the L1 RPC component is complete, we can start the zkNode setup. This is the most straightforward way to run a zkNode and it's fine for most use cases. 
Furthermore, this method is purely subjective and feel free to run this software in a different manner. For example, Docker is not required, you could simply use the Go binaries directly.
Let's start setting up our zkNode:

1. Download the installation script
``` bash
mkdir -p ./xlayer-node && cd ./xlayer-node
# testnet
wget curl -fsSL https://raw.githubusercontent.com/okx/Deploy/main/setup/zknode/run_xlayer_testnet.sh | bash -s init && cp ./testnet/example.env ./testnet/.env
```

2. The example.env file must be modified according to your configurations. Edit the .env file with your favourite editor (we'll use vim in this guide): 

``` bash
# testnet
vim ./testnet/.env
```

``` bash
# URL of a JSON RPC for Ethereum Sepolia testnet
XLAYER_NODE_ETHERMAN_URL = "http://your.L1node.url"

# PATH WHERE THE STATEDB POSTGRES CONTAINER WILL STORE PERSISTENT DATA
XLAYER_NODE_STATEDB_DATA_DIR = "./xlayer_testnet_datastatedb/statedb" # OR ./xlayer_testnet_datastatedb/ for testnet

# PATH WHERE THE POOLDB POSTGRES CONTAINER WILL STORE PERSISTENT DATA #
XLAYER_NODE_POOLDB_DATA_DIR = "./xlayer_testnet_data/pooldb" # OR ./xlayer_testnet_data/pooldb/ for testnet
```

3. Restore the latest L2 snapshot  locally database for synchronizing  L2 data quickly.
``` bash
# testnet
./run_xlayer_testnet.sh restore 
```

## Starting
Use the below command to start the zkNode instance:
``` bash
# testnet
./run_xlayer_testnet.sh start

docker ps -a
```

You will see a list of the following containers :
  - xlayer-rpc
  - xlayer-sync
  - xlayer-state-db
  - xlayer-pool-db
  - xlayer-prover

You should now be able to run queries to the JSON-RPC endpoint at http://localhost:8545.
Run the following query to get the most recently synchronized L2 block; if you call it every few seconds, you should see the number grow:
``` bash
curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}' http://localhost:8545
```

## Stopping
Use the below command to stop the zkNode instance:
``` bash
./run_xlayer_testnet.sh stop
```

## Restarting
Use the below command to stop the zkNode instance:
``` bash
# testnet
./run_xlayer_testnet.sh restart
```
## Updating
To update the zkNode software, run the below command, and the file ```./testnet/.env``` will be retained, the other config will be deleted.
``` bash
# testnet
./run_xlayer_testnet.sh update
```

## Troubleshooting
- It's possible that the machine you're using already uses some of the necessary ports. In this case, you can change them directly ```./testnet/docker-compose.yml```.
- If one or more containers are crashing, please check the logs using the command below:
``` bash
docker ps -a

docker logs <cointainer_name>
```
