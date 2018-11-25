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

end
