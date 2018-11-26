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

