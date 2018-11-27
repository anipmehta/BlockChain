defmodule BlockChainTest do
  use ExUnit.Case
  doctest BlockChain
#tests successful initialization of BlockChain
  test "starting a chain with genesis block" do
    IO.inspect("------Running BlockChain Test Cases--------\n\n\n\n")
    test_case_name = "starting a chain with genesis block"
    IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
    {:ok, block_chain_pid} = BlockChain.start_link()
    assert Enum.count(BlockChain.get_chain(block_chain_pid)) == 1
  end

# tests validity of the BlockChain by verifying that the blocks are themselves valid
# and that they are in correct order i.e. previous hash of the current block corresponds to
# the hash of the previous block
  test "valid block chain" do
    test_case_name = "valid block chain"
    IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
    difficulty = 2
    {:ok, block_chain_pid} = BlockChain.start_link()
    {:ok, user_a_id} = User.start_link()
    {:ok, user_b_id} = User.start_link()
    user_a_address = User.get_public_key(user_a_id)
    user_b_address = User.get_public_key(user_b_id)
    block_a_pid = BlockChain.mine_pending_transactions(block_chain_pid, user_a_address, difficulty)
    {:ok, txn_a_id} = Transaction.start_link(user_a_address, user_b_address, 500.0)
    User.sign_transaction(user_a_id, txn_a_id)
    {:ok, txn_b_id} = Transaction.start_link(user_b_address, user_a_address, 200.0)
    User.sign_transaction(user_b_id, txn_b_id)
    BlockChain.add_transaction(block_chain_pid, txn_a_id)
    BlockChain.add_transaction(block_chain_pid, txn_b_id)
    block_b_pid = BlockChain.mine_pending_transactions(block_chain_pid, user_b_address, difficulty)
    assert BlockChain.is_valid(block_chain_pid) == true
  end

#detects that the block chain is invalid given one block is invalid
  test "detect invalid block chain" do
    test_case_name = "detect invalid block chain"
    IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
    difficulty = 2
    {:ok, block_chain_pid} = BlockChain.start_link()
    {:ok, user_a_id} = User.start_link()
    {:ok, user_b_id} = User.start_link()
    user_a_address = User.get_public_key(user_a_id)
    user_b_address = User.get_public_key(user_b_id)
    block_a_pid = BlockChain.mine_pending_transactions(block_chain_pid, user_a_address, difficulty)
    {:ok, txn_a_id} = Transaction.start_link(user_a_address, user_b_address, 500.0)
    User.sign_transaction(user_a_id, txn_a_id)
    {:ok, txn_b_id} = Transaction.start_link(user_b_address, user_a_address, 200.0)
    User.sign_transaction(user_a_id, txn_b_id)
    BlockChain.add_transaction(block_chain_pid, txn_a_id)
    BlockChain.add_transaction(block_chain_pid, txn_b_id)
    block_b_pid = BlockChain.mine_pending_transactions(block_chain_pid, user_b_address, difficulty)
    assert BlockChain.is_valid(block_chain_pid) == false
  end

#Functional Test 1 : Simple scenario
#User A sends $50 to User B
#User A's balance reduces by $50 while B gains $50
  test "transact 50.0 from user_a to user_b" do
    test_case_name = "transact 50.0 from user_a to user_b"
    IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
    difficulty = 2
    {:ok, block_chain_pid} = BlockChain.start_link()
    {:ok, user_a_id} = User.start_link()
    {:ok, user_b_id} = User.start_link()
    user_a_address = User.get_public_key(user_a_id)
    user_b_address = User.get_public_key(user_b_id)
    block_a_pid = BlockChain.mine_pending_transactions(block_chain_pid, user_a_address, difficulty)
    {:ok, txn_a_id} = Transaction.start_link(user_a_address, user_b_address, 50.0)
    User.sign_transaction(user_a_id, txn_a_id)
    BlockChain.add_transaction(block_chain_pid, txn_a_id)
    block_b_pid = BlockChain.mine_pending_transactions(block_chain_pid, user_b_address, difficulty)
    assert BlockChain.get_balance(block_chain_pid, user_b_address) == 50.0 and BlockChain.get_balance(block_chain_pid, user_a_address) == -50.0
  end

  #Functional Test 2: Include mining reward
  # User A mines the first block
  #Transactions :
  # A sends $70 to B
  # B sends $50 to case
  #Balance at this point is checked : A:30 B:20 C:50 (A received $100 mining reward)
  #C mines the next Block
  #C sends $20 to B
  #A sends $20 to C
  #B sends $10 to A
  #B mines the next block
  #At the end of all these transactions the balance should be :
  # A :20  B:20  C :160 (C received $100 mining reward)
  # The mining reward for B is placed in the pool of pending transaction and it will reflect in B's account once another block takes up this transaction
    test "complex transactions scenario with multiple block and mining Rewards" do
      test_case_name = "complex transactions scenario with multiple block and mining Rewards"
      IO.inspect("--------------Running Test: #{test_case_name}----------------")
      difficulty = 4
      {:ok, block_chain_pid} = BlockChain.start_link()
      {:ok, user_a_id} = User.start_link()
      BlockChain.add_user(block_chain_pid, user_a_id)
      user_a_address = User.get_public_key(user_a_id)
      mining_reward = 100.0
      BlockChain.update_mining_reward(block_chain_pid, mining_reward)
      BlockChain.mine_pending_transactions(block_chain_pid, user_a_address, difficulty)
      IO.inspect("first block mined, reward sent to user A")
      {:ok, user_b_id} = User.start_link()
      {:ok, user_c_id} = User.start_link()
      BlockChain.add_user(block_chain_pid, user_b_id)
      BlockChain.add_user(block_chain_pid, user_c_id)
      user_b_address = User.get_public_key(user_b_id)
      user_c_address = User.get_public_key(user_c_id)


      {:ok, txn_a_id} = Transaction.start_link(user_a_address, user_b_address, 70.0)
      User.sign_transaction(user_a_id, txn_a_id)
      BlockChain.add_transaction(block_chain_pid, txn_a_id)

      {:ok, txn_b_id} = Transaction.start_link(user_b_address, user_c_address, 50.0)
      User.sign_transaction(user_b_id, txn_b_id)
      BlockChain.add_transaction(block_chain_pid, txn_b_id)
      BlockChain.mine_pending_transactions(block_chain_pid, user_c_address, difficulty)
      IO.inspect("second block mined, reward sent to user C")

      user_a_balance = BlockChain.get_balance(block_chain_pid, user_a_address)
      user_b_balance = BlockChain.get_balance(block_chain_pid, user_b_address)
      user_c_balance = BlockChain.get_balance(block_chain_pid, user_c_address)
      IO.inspect("Balances after before the start of mining of next block..")
      IO.inspect(user_a_balance)
      IO.inspect(user_b_balance)
      IO.inspect(user_c_balance)
      check1 = user_a_balance == 30.0 and user_b_balance==20.0 and user_c_balance==50.0


      {:ok, txn_c_id} = Transaction.start_link(user_c_address, user_b_address, 10.0)
      User.sign_transaction(user_c_id, txn_c_id)
      BlockChain.add_transaction(block_chain_pid, txn_c_id)

      {:ok, txn_d_id} = Transaction.start_link(user_a_address, user_c_address, 20.0)
      User.sign_transaction(user_a_id, txn_d_id)
      BlockChain.add_transaction(block_chain_pid, txn_d_id)

      {:ok, txn_e_id} = Transaction.start_link(user_b_address, user_a_address, 10.0)
      User.sign_transaction(user_b_id, txn_e_id)
      BlockChain.add_transaction(block_chain_pid, txn_e_id)
      BlockChain.mine_pending_transactions(block_chain_pid, user_b_address, difficulty)

      user_a_balance = BlockChain.get_balance(block_chain_pid, user_a_address)
      user_b_balance = BlockChain.get_balance(block_chain_pid, user_b_address)
      user_c_balance = BlockChain.get_balance(block_chain_pid, user_c_address)
      IO.inspect("Balances after end of all transactions......")
      IO.inspect(user_a_balance)
      IO.inspect(user_b_balance)
      IO.inspect(user_c_balance)
      check2 = user_a_balance == 20.0 and user_b_balance == 20.0 and user_c_balance == 160.0 and BlockChain.is_valid(block_chain_pid)

      assert check1 == true and check2 == true
    end


  # test "greets the world" do
  #   assert BlockChain.hello() == :world
  # end
end
