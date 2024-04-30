When your permitssionless RPC encounters a mismatch, you can use this method to restore it.

## 1 Stop xlayer-sync and xlayer-rpc services
``` bash
docker stop xlayer-sync
docker stop xlayer-rpc
```
## 2 Select max  verified batch
``` bash
PGPASSWORD=state_password psql -h 127.0.0.1 -p 5432 -d state_db -U state_user

SELECT max(batch_num) FROM state.verified_batch;
```

## 3 Look for the target block and batch to delete
- Look for this batch in https://www.oklink.com/xlayer-test/batch/330000
and get "Sequence Tx Hash" value (0xf5bcff8bc5e03be47e36d642d26f0551ff4a66094e1fb67c9e02ec739c7fca82)
- Go to previous batches (you can use "<" button) until you reach the first batch sequenced with the same "Sequence Tx Hash" (in this example **329992**). 
- Look for the "Sequence Tx Hash" in etherscan (https://sepolia.etherscan.io/tx/0xf5bcff8bc5e03be47e36d642d26f0551ff4a66094e1fb67c9e02ec739c7fca82) to get the L1 block where that tx was confirmed (in this example **5517146**). 
## 6 Delete the block and batch
``` bash
delete from state.block where block_num >= 5517146; 
delete from state.batch where batch_num >= 329992;
```
## 7 Start the sync service to sync again.