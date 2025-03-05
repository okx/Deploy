# Setup Production Erigon

`cdk-erigon` is a fork of Erigon, optimized for syncing with the XLayer network.

## Why This README Was Updated

The original README lacked important details and troubleshooting steps, leading to difficulties during setup. This improved version includes:
- Clearer system requirements
- A recommended Docker setup to avoid dependency issues
- Additional build instructions for better compatibility
- Enhanced configuration guidance
- Troubleshooting tips

## Minimum System Requirements
- **16 GB RAM**
- **8 core CPU**
- **500 GB Storage** (This will increase over time)
- **Ubuntu 20.04+ (or use Docker)**

## Recommended Setup (Using Docker)
To avoid compatibility issues with GCC, GLIBC, and Go versions, we recommend using Docker:

```bash
docker build -t cdk-erigon:latest .
docker run -it --rm \
    -p 8545:8545 \
    -p 30303:30303 \
    -v "$PWD/xlayerconfig-mainnet.yaml:/home/erigon/xlayerconfig-mainnet.yaml" \
    cdk-erigon:latest \
    --config=/home/erigon/xlayerconfig-mainnet.yaml
```

If you prefer a manual installation, follow the steps below.

## Start Erigon RPC Node (Manual Installation)

### Build
```bash
git clone https://github.com/0xPolygonHermez/cdk-erigon.git
cd cdk-erigon
git checkout v2.61.0 # Checkout the latest stable version

make cdk-erigon
```

### Config
```bash
cp xlayerconfig-mainnet.yaml.example xlayerconfig-mainnet.yaml
```
Modify and replace parameters as needed:

```yaml
datadir: /your/data/dir
zkevm.l1-rpc-url: http://your-l1-rpc-url:8545

zkevm.address-sequencer: "0xAF9d27ffe4d51eD54AC8eEc78f2785D7E11E5ab1"
zkevm.address-zkevm: "0x2B0ee28D4D51bC9aDde5E58E295873F61F4a0507"
zkevm.address-admin: "0x491619874b866c3cDB7C8553877da223525ead01"
zkevm.address-rollup: "0x5132A183E9F3CB7C848b0AAC5Ae0c4f0491B7aB2"
zkevm.address-ger-manager: "0x580bda1e7A0CFAe92Fa7F6c20A3794F169CE3CFb"
```

### Start Erigon Node
```bash
./build/bin/cdk-erigon --config="./xlayerconfig-mainnet.yaml"
```

## Troubleshooting

### Common Issues

#### 1. **GCC Version Too Old (Amazon Linux 2)**
**Error:** `gcc: error: unrecognized command line option '-std=c17'`

**Solution:** Upgrade GCC manually or use Docker:
```bash
sudo yum groupinstall "Development Tools" -y
sudo yum install -y gcc gcc-c++ kernel-devel gmp-devel mpfr-devel libmpc-devel
```

#### 2. **GLIBC Version Incompatibility**
**Error:** `undefined reference to 'pthread_setspecific@GLIBC_2.34'`

**Solution:**
- Avoid upgrading GLIBC directly (can break the system)
- Use Docker or a newer Ubuntu version

#### 3. **Go Version Too Old**
**Error:** `minimum required Golang version is 1.21`

**Solution:**
```bash
wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
export PATH=/usr/local/go/bin:$PATH
go version
```

#### 4. **Permission Issues in Docker**
**Error:** `mkdir /home/erigon-data: permission denied`

**Solution:** Ensure that the Erigon user inside the container has write access. If necessary, change the `datadir` path to `/home/erigon/data/xlayer-mainnet` and ensure it's writable inside the container.

---
## Summary
- The original guide missed key troubleshooting details and compatibility issues.
- This updated guide includes a recommended Docker setup for stability.
- Troubleshooting steps were added for common build and run-time issues.
- Use Docker if running on Amazon Linux 2 to avoid GLIBC/GCC problems.

If you encounter further issues, check the logs and verify dependencies before proceeding.

