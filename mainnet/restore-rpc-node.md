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
- Look for this batch in https://www.oklink.com/xlayer/batch/10000
and get "Sequence Tx Hash" value (0x841fe25fb92e35a2f6629f195702553000dd38c911b52d479aeb78ac30c2ddf9)
- Go to previous batches (you can use "<" button) until you reach the first batch sequenced with the same "Sequence Tx Hash" (in this example **9993**). 
- Look for the "Sequence Tx Hash" in etherscan (https://etherscan.io/tx/0x841fe25fb92e35a2f6629f195702553000dd38c911b52d479aeb78ac30c2ddf9) to get the L1 block where that tx was confirmed (in this example **19710218**). 
## 6 Delete the block and batch
``` bash
delete from state.block where block_num >= 19710218; 
delete from state.batch where batch_num >= 9993;
```
## 7 Start the sync service to sync again.