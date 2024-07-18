# config the branch of the repos
erigon_branch="zjg/support-validium"
aggregator_branch="develop"
synchronizer_branch="develop"
ethtx_manager_branch="main"
sequence_sender_branch="develop"

git clone -b ${erigon_branch} https://github.com/okx/xlayer-erigon.git 
git clone -b ${aggregator_branch} https://github.com/okx/xlayer-aggregator.git
git clone -b ${synchronizer_branch} https://github.com/okx/xlayer-synchronizer-l1.git
git clone -b ${ethtx_manager_branch} https://github.com/okx/xlayer-ethtx-manager.git
git clone -b ${sequence_sender_branch} https://github.com/okx/xlayer-sequence-sender.git

# replace the go.mod file with the correct path
echo -e "\nreplace (\n\tgithub.com/0xPolygonHermez/zkevm-ethtx-manager => ../xlayer-ethtx-manager\n\tgithub.com/0xPolygonHermez/zkevm-synchronizer-l1 => ../xlayer-synchronizer-l1\n)" >> xlayer-aggregator/go.mod
echo -e "\nreplace (\n\tgithub.com/0xPolygonHermez/zkevm-ethtx-manager => ../xlayer-ethtx-manager\n\tgithub.com/0xPolygonHermez/zkevm-synchronizer-l1 => ../xlayer-synchronizer-l1\n)" >> xlayer-sequence-sender/go.mod

# replace the docker-compose file with the correct image
sed -i.bak '/image:.*zkevm-seqsender/s|image:.*zkevm-seqsender:.*|image: zkevm-seqsender|' ./xlayer-erigon/test/docker-compose.yml
sed -i.bak '/image:.*zkevm-aggregator/s|image:.*zkevm-aggregator:.*|image: zkevm-aggregator|' ./xlayer-erigon/test/docker-compose.yml
