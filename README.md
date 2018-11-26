# BlockChain

**BitCoin Protocol**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `blockchain` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:blockchain, "~> 0.1.0"}
  ]
end
```
# Group Info
 - Anip Mehta  UFID : 96505636
 - Aniket Sinha UFID : 69598035


# DOS Project4.1

## Implementation of Bitcoin Protocol in Elixir

### Functionalities Implemented:
1) Mining of blocks with given difficulty/threshold using Bitcoin Protocol
2) Adding transactions to the blockchain
3) Verify the validity of transactions and ability to display the User's balance(wallet)
4) Bonus: Mining reward functionality has also been implemented to reward the miners of the block

### Unit Testcases: 
All the testcases are included in a separate directory Test

#### 1.block_test.exs : 
```
1)test "check hash-code with difficulty 5" - It validates that the hash of the mined block with threshold 5 starts with 5 zeroes
2) test "check hash-code with difficulty 3" - It validates that the hash of the mined block with threshold 3 starts with 3 zeroes
3)test "block with no Transactions" - It checks the validity of a block with no transact Itions
4)test "check valid block"  - It verifies that all transactions done within a block are valid
5)test "detect invalid block" - It verifies that a block with invalid transactions is flagged as an invalid block
```
#### 2.transaction_test.exs
```
1) test "transaction validity" - It tests the validity of the transaction
User a sends $50 to user b signing with its public_key
Here we verify that the transaction was indeed signed by User a.

2) test "detecting invalid transaction when receiver impersonates the sender" - It tests successful flagging of invalid transactions.
   User a sends $50 to user b signing with its public_key
   User b falsely claims that it is he who sent the money to himself
   We are able to verify that the transaction was not signed by User b.
  
3)test "detecting invalid transaction when a different user impersonates the sender" - It too tests successful flagging of invalid      transactions.
   User a sends $50 to user b signing with its public_key.
   User C falsely claims that it is he who sent the money.
   We are able to verify that the transaction was not signed by User C
```
#### 3.blockchain_test.exs
```
1)test "starting a chain with genesis block" - It tests successful initialization of BlockChain.

2)test "valid block chain" - It tests validity of the BlockChain by verifying that the blocks are themselves valid
 and that they are in correct order i.e. previous hash of the current block corresponds to the hash of the previous block.
 
3)test "detect invalid block chain" - It detects that the block chain is invalid given one block is invalid.
```

### Functional Tests

All the functional tests are part of the file blockchain_test.exs

#### 1.Functional Test 1 : Simple scenario
```
test "transact 50.0 from user_a to user_b" :
User A sends $50 to User B
#User A's balance reduces by $50 while B gains $50
``` 
#### 2.Functional Test 2: Include mining reward (Bonus)
```
test "complex transactions scenario with multiple block and mining Rewards" : 
User A mines the first block
  Transactions :
   A sends $70 to B
   B sends $50 to case
  Balance at this point is checked : A:30 B:20 C:50 (A received $100 mining reward)
  C mines the next Block
  C sends $20 to B
  A sends $20 to C
  B sends $10 to A
  B mines the next block
  At the end of all these transactions the balance should be :
   A :20  B:20  C :160 (C received $100 mining reward)
   The mining reward for B is placed in the pool of pending transaction and it will reflect in B's account once another block takes up this transaction
   ```

## Instructions

### Input
Run : 
```
mix test
```
### Output

You should see all 13 testcases succesfully run with 0 failures (along with some console output).
```
Congrats! New Block Mined with hash = 001802F3229C67C4B34686350EABCE0497B648B2
Congrats! New Block Mined with hash = 001802F3229C67C4B34686350EABCE0497B648B2
..Congrats! New Block Mined with hash = 0000305AE15D9BC0547497EA1252BF37D4535390
Congrats! New Block Mined with hash = 00009912E737A9B04A05F5C9FA38CB802FBACC8B
30.0
20.0
50.0
Congrats! New Block Mined with hash = 00009912E737A9B04A05F5C9FA38CB802FBACC8B
20.0
20.0
160.0
.Congrats! New Block Mined with hash = 00BBC24A2E77803889AC9C1FC431CD29BE152C56
Congrats! New Block Mined with hash = 00BBC24A2E77803889AC9C1FC431CD29BE152C56
.Congrats! New Block Mined with hash = 00BBC24A2E77803889AC9C1FC431CD29BE152C56
Congrats! New Block Mined with hash = 00BBC24A2E77803889AC9C1FC431CD29BE152C56
.........

Finished in 5.5 seconds
13 tests, 0 failures

```

## Bonus

The functionality of providing mining rewards to the miners of the Blocks has been implemented. We have demonstrated this functionality in Functional Test 2. Each time a User mines a new block, he/she is awarded a mining reward(in our test we have considered it to be $100). This mining reward is added to the pending transactions and is owned by the user once this transaction is processed by any block. 
