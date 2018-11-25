defmodule BlockTest do
  use ExUnit.Case
  doctest Block
   test "check hash-code with difficulty 5" do
     {:ok, pid} = Block.start_link()
     previous_hash = Block.get_previous_hash(pid)
     time_stamp = Integer.to_string(Block.get_time_stamp(pid))
     transactions = List.to_string(Block.get_transactions(pid))
     nonce = Block.get_nonce(pid)
     hash = Block.generate_hash(5, pid, previous_hash, time_stamp, transactions, nonce)
     assert String.match?(hash, ~r/^00000/);
    end

    test "check hash-code with difficulty 3" do
      {:ok, pid} = Block.start_link()
      previous_hash = Block.get_previous_hash(pid)
      time_stamp = Integer.to_string(Block.get_time_stamp(pid))
      transactions = List.to_string(Block.get_transactions(pid))
      nonce = Block.get_nonce(pid)
      hash = Block.generate_hash(3, pid, previous_hash, time_stamp, transactions, nonce)
      assert String.match?(hash, ~r/^000/);
     end

     test "check validty of transactions" do
       {:ok, user_a_id} = User.start_link()
       {:ok, user_b_id} = User.start_link()
       user_a_address = User.get_public_key(user_a_id)
       user_b_address = User.get_public_key(user_b_id)
       {:ok, txn_a_id} = Transaction.start_link(user_a_address, user_b_address, 500.0)
       User.sign_transaction(user_a_id, txn_a_id)
       {:ok, txn_b_id} = Transaction.start_link(user_b_address, user_a_address, 200.0)
       User.sign_transaction(user_b_id, txn_b_id)
       transaction_list = [txn_a_id, txn_b_id]
       {:ok, pid} = Block.start_link()
       Block.update_transactions(pid, transaction_list)
       assert Block.is_valid(pid) == true
     end

     test "check invalidty of transactions" do
       {:ok, user_a_id} = User.start_link()
       {:ok, user_b_id} = User.start_link()
       user_a_address = User.get_public_key(user_a_id)
       user_b_address = User.get_public_key(user_b_id)
       {:ok, txn_a_id} = Transaction.start_link(user_a_address, user_b_address, 500.0)
       User.sign_transaction(user_a_id, txn_a_id)
       {:ok, txn_b_id} = Transaction.start_link(user_b_address, user_a_address, 200.0)
       User.sign_transaction(user_a_id, txn_b_id)
       transaction_list = [txn_a_id, txn_b_id]
       {:ok, pid} = Block.start_link()
       Block.update_transactions(pid, transaction_list)
       assert Block.is_valid(pid) == false
     end
end