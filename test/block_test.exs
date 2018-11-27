defmodule BlockTest do
  use ExUnit.Case
  doctest Block

  #validates that the hash of the mined block with threshold 5 starts with 5 zeroes
   test "check hash-code with difficulty 5" do
     IO.inspect("------Running Block Test Cases--------\n\n\n\n\n\n")
     test_case_name = "check hash-code with difficulty 5"
     IO.inspect("--------------Running Test: #{test_case_name}----------------")
     {:ok, pid} = Block.start_link()
     previous_hash = Block.get_previous_hash(pid)
     time_stamp = Integer.to_string(Block.get_time_stamp(pid))
     transactions = List.to_string(Block.get_transactions(pid))
     nonce = Block.get_nonce(pid)
     hash = Block.generate_hash(5, pid, previous_hash, time_stamp, transactions, nonce)
     assert String.match?(hash, ~r/^00000/);
    end

#validates that the hash of the mined block with threshold 3 starts with 3 zeroes
    test "check hash-code with difficulty 3" do
      test_case_name = "check hash-code with difficulty 3"
      IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
      {:ok, pid} = Block.start_link()
      previous_hash = Block.get_previous_hash(pid)
      time_stamp = Integer.to_string(Block.get_time_stamp(pid))
      transactions = List.to_string(Block.get_transactions(pid))
      nonce = Block.get_nonce(pid)
      hash = Block.generate_hash(3, pid, previous_hash, time_stamp, transactions, nonce)
      assert String.match?(hash, ~r/^000/);
     end

#checks the validity of a block with no transactions
     test "block with no Transactions" do
       test_case_name = "block with no Transactions"
       IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
       {:ok, pid} = Block.start_link()
       assert Block.is_valid(pid) == true
     end

    # verifies that all transactions done within a block are valid
     test "check valid block" do
       test_case_name = "check valid block"
       IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
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

#verifies that a block with invalid transactions is flagged as an invalid block
     test "detect invalid block" do
       test_case_name = "detect invalid block"
       IO.inspect("--------------Running Test: #{test_case_name}----------------\n")
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
