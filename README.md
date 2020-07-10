# neo4j-reactome
Deploying [reactome.org](https://reactome.org) database via docker


Enter build directory and run:

`docker build -t reactomen4j .`

During the build, it loads reactome database from its original site, load it, and check if load is OK.
In the end, you will see test queries on the loaded DB, including number of different records and last modification marks of the reactome DB.

Next, activate the container using this script:

`./neo4j.sh`

It will create *neoreo-container* container from *reactomen4j* image.
Note, that we store database data inside the container in this build. 
Thus, do not remove container if you made some changes in the database.
