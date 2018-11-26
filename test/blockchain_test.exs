defmodule BlockChainTest do
  use ExUnit.Case
  doctest BlockChain

  test "starting a chain with genesis block" do
    {:ok, block_chain_pid} = BlockChain.start_link()
    assert Enum.count(BlockChain.get_chain(block_chain_pid)) == 1
  end

  test "complex transactions scenario with multiple block and mining Rewards" do
    difficulty = 4
    {:ok, block_chain_pid} = BlockChain.start_link()
    {:ok, user_a_id} = User.start_link()
    BlockChain.add_user(block_chain_pid, user_a_id)
    user_a_address = User.get_public_key(user_a_id)
    mining_reward = 100.0
    BlockChain.update_mining_reward(block_chain_pid, mining_reward)
    BlockChain.mine_pending_transactions(block_chain_pid, user_a_address, difficulty)
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
    User.sign_transaction(user_b_id, txn_a_id)
    BlockChain.add_transaction(block_chain_pid, txn_b_id)
    BlockChain.mine_pending_transactions(block_chain_pid, user_c_address, difficulty)

    user_a_balance = BlockChain.get_balance(block_chain_pid, user_a_address)
    user_b_balance = BlockChain.get_balance(block_chain_pid, user_b_address)
    user_c_balance = BlockChain.get_balance(block_chain_pid, user_c_address)
    IO.inspect(user_a_balance)
    IO.inspect(user_b_balance)
    IO.inspect(user_c_balance)
    check1 = user_a_balance == 30.0 and user_b_balance==20.0 and user_c_balance==50.0


    {:ok, txn_c_id} = Transaction.start_link(user_c_address, user_b_address, 10.0)
    User.sign_transaction(user_c_id, txn_c_id)
    BlockChain.add_transaction(block_chain_pid, txn_c_id)

    {:ok, txn_d_id} = Transaction.start_link(user_a_address, user_c_address, 20.0)
    User.sign_transaction(user_a_id, txn_a_id)
    BlockChain.add_transaction(block_chain_pid, txn_d_id)

    {:ok, txn_e_id} = Transaction.start_link(user_b_address, user_a_address, 10.0)
    User.sign_transaction(user_b_id, txn_a_id)
    BlockChain.add_transaction(block_chain_pid, txn_e_id)
    BlockChain.mine_pending_transactions(block_chain_pid, user_b_address, difficulty)

    user_a_balance = BlockChain.get_balance(block_chain_pid, user_a_address)
    user_b_balance = BlockChain.get_balance(block_chain_pid, user_b_address)
    user_c_balance = BlockChain.get_balance(block_chain_pid, user_c_address)
    IO.inspect(user_a_balance)
    IO.inspect(user_b_balance)
    IO.inspect(user_c_balance)
    check2 = user_a_balance == 20.0 and user_b_balance == 20.0 and user_c_balance == 160.0

    assert check1 == true and check2 == true
  end

  test "valid block chain given all the valid blocks" do
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

  test "invalid block chain given one block is invalid" do
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

  test "transact 50.0 from user_a to user_b" do
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



  # test "greets the world" do
  #   assert BlockChain.hello() == :world
  # end
end
