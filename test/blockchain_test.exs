defmodule BlockChainTest do
  use ExUnit.Case
  doctest BlockChain

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

  # test "greets the world" do
  #   assert BlockChain.hello() == :world
  # end
end
