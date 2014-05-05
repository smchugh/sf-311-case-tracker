Tracker for 311 Cases in the SF Area
---------------------------

### Description
This project performs a nightly load of the data from sfgov.org and provides an interface for consuming that data
 - http://data.sfgov.org/resource/vw6y-z8j6.json
 - [Described Here](http://data.sfgov.org/Service-Requests-311-/Case-Data-from-San-Francisco-311/vw6y-z8j6)

The case data can be accessed as follows:
 - All the cases
   - GET /cases.json
 - Cases opened since a specified UNIX timestamp
   - GET /cases.json?since=1398465719
 - Cases that are in specific state (Open, Closed)
   - GET /cases.json?status=open
 - Cases that were sourced through a given source (Voice In, Email In)
   - GET /cases.json?source=Voice%20In
 - Cases that were created within 5 mile radius of the given coordinate
   - GET /cases.json?near=37.77,-122.48
 - Any combination of the above filters
   - GET /cases.json?near=37.77,-122.48&status=open&source=Voice%20In

### Future Work
 - Optimize load job using one of the methods described [here](https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/)
 - Add more filter options
 - Improve accuracy of within_five_miles scope to actually look for points in a cirlce, rather than a square
 - Remove unnecessary Rails files
