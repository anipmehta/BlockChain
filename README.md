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
"--------------Running Test: detect invalid block chain----------------\n"
Congrats! New Block Mined with hash = 00ADE77533CBBA05202B875CB09C6B54B7199FDC
Congrats! New Block Mined with hash = 00D66D48992F471C4F5AB3B496C047730C59A440
."--------------Running Test: complex transactions scenario with multiple block and mining Rewards----------------"
Congrats! New Block Mined with hash = 00001A91F2038663ECB9E723C9711E764B7C3EC7
"first block mined, reward sent to user A"
Congrats! New Block Mined with hash = 000040EA1A478B8FB5BFD9C18636D857242C6FBC
"second block mined, reward sent to user C"
"Balances after before the start of mining of next block.."
30.0
20.0
50.0
Congrats! New Block Mined with hash = 00000F44960C825F66599A55CD31405ADE7503B4
"Balances after end of all transactions......"
20.0
20.0
160.0
."--------------Running Test: transact 50.0 from user_a to user_b----------------\n"
Congrats! New Block Mined with hash = 0071909DD1C93182BA4233A71F74C2BD9144FE41
Congrats! New Block Mined with hash = 00FE1F17A48668531F3A30CD18E0C07806220353
."------Running BlockChain Test Cases--------\n\n\n\n"
"--------------Running Test: starting a chain with genesis block----------------\n"
."--------------Running Test: valid block chain----------------\n"
Congrats! New Block Mined with hash = 00FC51E8A868100D9873416E9A558F26C120F205
Congrats! New Block Mined with hash = 000C90DEA4BFF44CF9B061B13B86D206E47A603C
."--------------Running Test: block with no Transactions----------------\n"
."--------------Running Test: detect invalid block----------------\n"
."--------------Running Test: check valid block----------------\n"
."------Running Block Test Cases--------\n\n\n\n\n\n"
"--------------Running Test: check hash-code with difficulty 5----------------"
."--------------Running Test: check hash-code with difficulty 3----------------\n"
."------Running Transaction Test Cases--------\n\n\n\n\n"
"--------------Running Test: transaction validity----------------\n"
."--------------Running Test: detecting invalid transaction when a different user impersonates the sender----------------\n"
."--------------Running Test: detecting invalid transaction when receiver impersonates the sender----------------\n"
.

Finished in 5.6 seconds
13 tests, 0 failure

```

## Bonus

The functionality of providing mining rewards to the miners of the Blocks has been implemented. We have demonstrated this functionality in Functional Test 2. Each time a User mines a new block, he/she is awarded a mining reward(in our test we have considered it to be $100). This mining reward is added to the pending transactions and is owned by the user once this transaction is processed by any block.
