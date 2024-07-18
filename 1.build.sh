# docker stop $(docker ps -aq); docker rm $(docker ps -aq);docker ps -a
# docker rmi --force $(docker images -q)
# docker system prune -a --volumes

cd xlayer-aggregator; git pull; cd -;
cd xlayer-sequence-sender; git pull; cd -;
cd xlayer-ethtx-manager; git pull; cd -;
cd xlayer-synchronizer-l1; git pull; cd -;

docker build -t zkevm-aggregator -f ./Dockerfile.aggregator .
docker build -t zkevm-seqsender -f ./Dockerfile.seqsender .

cd xlayer-erigon; make build-docker
