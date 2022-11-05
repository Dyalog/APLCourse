# Problem ideas
## cells and axes
### car wash
- rates times times? then check the lowest in each matrix

We want to choose which to use of 3 competing car wash services. They are all the same distance from our house, so the only thing we will use to choose from is price. We will choose to use the service with the lowest price.

Sometimes lots of people want to get their cars washed at the same time, and some times not very many people do. This means that the demand changes throughout the day and the week. To try and balance the demand, the services vary their pricing throughout the day to incentivise people to try and go at different times.

The services are open from 08:30 until 18:30, 7 days a week. The rates for each car wash, 1 2 3 (TODO: snazzy names) are given as a 3-row matrix.

`⊢rates ← .99+?3 12⍴20` TODO should very sensibly?

Want to end up with a 3D array from which to return a single number, or perhaps a vector or matrix. We want to determine, for each day of the week and each time of day, which car wash 1 2 or 3 should we choose to go to.

We start with 3 vectors and must use outer products to generate the 3D array, then reduce?