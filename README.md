# Blockchain (Project 4.2)

## Installation
To start your Phoenix server:

  * `cd blockchain`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
  
  # Group Info
 - Anip Mehta  UFID : 96505636
 - Aniket Sinha UFID : 69598035

  ## What we have implemented:

  * Simulation of distributed blockchain protocol (built over 4.1)
  *  A web interface using Phoenix that allows access to the simulation using a web browser.
    The simulation has the following capabilities:
     * New users can join the system, send bitcoins to each other and mine new blocks.
     * The transactions of the users get added to a pool of pending transactions.
     * A block can pick transactions from the pool and complete after verification.
     * At any instance of time, one can view the users and their respective balance in the users graph.
     * Also, one can view the bitcoins transacted by each block in another graph. 
   #### A brief walkthrough of the code and functionality is expalianed in a short video.
   #### Below are the screenshots of the functionality as seen in the browser :
   
   This is the first page you see when you go to (http://localhost:4000)
   
   ![image](https://user-images.githubusercontent.com/4914264/49977027-8fb07300-ff12-11e8-9641-ca6d64c7c19c.png)
   
   click on continue
   
   ![image](https://user-images.githubusercontent.com/4914264/49977103-02215300-ff13-11e8-906a-ca2b91a61313.png)

   click on create user
   
   ![image](https://user-images.githubusercontent.com/4914264/49977190-588e9180-ff13-11e8-85eb-7c10589e245d.png)
    
   New user has been created. Click on view user. You will see one row for a new user.
   Go back and click on mine block
   
   ![image](https://user-images.githubusercontent.com/4914264/49977276-b622de00-ff13-11e8-8bb3-82e547a188c7.png)
   
   Click on mine block.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977309-dce11480-ff13-11e8-8c94-5902853c0455.png)
   
   Go back. Now you see one pending transaction that of the mining reward.  
   
   ![image](https://user-images.githubusercontent.com/4914264/49977366-1d409280-ff14-11e8-8f93-b9327c6e4db2.png)
   
   Mine another block by the same user.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977428-51b44e80-ff14-11e8-8caa-061ac1c84287.png)
   
   Go to view users. Click on View button.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977499-8aecbe80-ff14-11e8-8e7c-ae003665cfc0.png)

   You will see the mining reward for mining previous block appear in user's balance.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977641-18c8a980-ff15-11e8-9bfe-d71d186db9a4.png)
   
   Create another user.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977729-76f58c80-ff15-11e8-8354-321d7bc3cf3c.png)
   
   Go to view user. Click on View button of 2nd (earlier) user. 
   Send 23 bitcoins to the newly created user. Click on create transaction.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977865-f6835b80-ff15-11e8-8201-a45647ee407d.png)
   
   You will see 2 pending transactions one mining reward for the previus block and the other for sending the bitcoins.
   Mine another block that will process these transactions.
   
   ![image](https://user-images.githubusercontent.com/4914264/49978019-8d501800-ff16-11e8-9bd8-58fb62903222.png)
   
   Click on vew user. Click on the view button of the user F5VElBhAY6joKm9E3588B.
   You can see his balance has increased to 23 bitcoins.
   
   ![image](https://user-images.githubusercontent.com/4914264/49978095-e3bd5680-ff16-11e8-96b7-c3a53d0fc13a.png)
   
   Now check the balance of the other user in the same way. His balance must be 200(mining reward for mining 2 blocks) - 23 (amount sent to other user) = 177.
   
   ![image](https://user-images.githubusercontent.com/4914264/49978159-3d258580-ff17-11e8-8b5e-e2d15466b196.png)
   
   You can view the amount transacted by the blocks in a chart by clicking on Block Transaction Graph.
   
   ![image](https://user-images.githubusercontent.com/4914264/49978229-837ae480-ff17-11e8-8010-a80addc3a0e8.png)
   
   You can see the users' balance as a graph by clicking on User balance graph.
   
   ![image](https://user-images.githubusercontent.com/4914264/49978274-be7d1800-ff17-11e8-98e8-3d5c072f84d1.png)
   
   
This was a walkthrough of the basic functionality implemented.
#### For a more complex scenario where we have more than 100 users, please visit the video link. 
  
## Instructions

* Execute all the commands outlined in installation.
* Go to (http://localhost:4000)
* Perform the steps shown in the screenshots above.

## Bonus 

Implemented an interface for "transacting" bitcoins using Phoenix and made it part of the simulated network.
