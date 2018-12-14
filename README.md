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
   
   ![image](https://user-images.githubusercontent.com/4914264/49977027-8fb07300-ff12-11e8-9641-ca6d64c7c19c.png)
   
   click on continue
   
   ![image](https://user-images.githubusercontent.com/4914264/49977103-02215300-ff13-11e8-906a-ca2b91a61313.png)

   click on create user
   
   ![image](https://user-images.githubusercontent.com/4914264/49977190-588e9180-ff13-11e8-85eb-7c10589e245d.png)
    
   New user has been created. Click on view user.
   
   ![image](https://user-images.githubusercontent.com/4914264/49977190-588e9180-ff13-11e8-85eb-7c10589e245d.png)

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
   
   

   
  ### Scenario 1:
  
## Instructions

* Perform the steps outlined in installation above.
* Go to (http://localhost:4000)
* Perform the steps mentioned in scenarios above making use of the screenshots.

## Bonus 

Implemented an interface for "transacting" bitcoins using Phoenix and made it part of the simulated network.
