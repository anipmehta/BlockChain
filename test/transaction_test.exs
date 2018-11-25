defmodule TransactionTest do
  use ExUnit.Case
  doctest Transaction

#tests the validity of the transaction
#User a sends $50 to user b signing with its public_key
#Here we verify that the transaction was indeed signed by User a
  test "transaction validity" do
    {:ok, user_a_id} = User.start_link()
    from_address = User.get_public_key(user_a_id)
    {:ok, user_b_id} = User.start_link()
    to_address = User.get_public_key(user_b_id)
    amount = 50.0;
    {:ok, txn_id} = Transaction.start_link(from_address,to_address,amount)
    User.sign_transaction(user_a_id, txn_id)
    assert Transaction.verify_transaction(txn_id,from_address)
   end

   #successfully flagging invalid transactions
   #User a sends $50 to user b signing with its public_key
   #User b falsely claims that it is he who sent the money to himself
   #We are able to verify that the transaction was not signed by User b
     test "detecting invalid transaction" do
       {:ok, user_a_id} = User.start_link()
       from_address = User.get_public_key(user_a_id)
       {:ok, user_b_id} = User.start_link()
       to_address = User.get_public_key(user_b_id)
       amount = 50.0;
       {:ok, txn_id} = Transaction.start_link(from_address,to_address,amount)
       User.sign_transaction(user_a_id, txn_id)
       assert Transaction.verify_transaction(txn_id,to_address) == false
      end

end
