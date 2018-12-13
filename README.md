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

  1. Simulation of distributed blockchain protocol (built over 4.1)
  2. A web interface using Phoenix that allows access to the simulation using a web browser.
    The simulation has the following capabilities:
    New users can join the system, send bitcoins to each other and mine new blocks.
    The transactions of the users get added to a pool of pending transactions.
    A block can pick transactions from the pool and complete after verification.
    At any instance of time, one can view the users and their respective balance in the users graph.
    Also, one can view the bitcoins transacted by each block in another graph. 
    
    A brief walkthrough of the code and functionality is expalianed in a short video.
    Below are the screenshots of the functionality as seen in the browser :
    
    Scenario 1:

## Instructions

1.Perform the steps outlined in installation above.
2. Go to (http://localhost:4000)
3. Perform the steps mentioned in scenarios above making use of the screenshots.

## Bonus 

Implemented an interface for "transacting" bitcoins using Phoenix and made it part of the simulated network.
