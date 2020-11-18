# Deploy
Deploying [reactome.org](https://reactome.org) database via docker


Enter build directory and run:

`docker build -t reactomen4j .`

During the build, it loads reactome database from its original site, load it, and check if load is OK.
In the end, you will see test queries on the loaded DB, including number of different records and last modification marks of the reactome DB.

Next, activate the container using this script:

`./neo4j.sh`

It will create *neoreo-container* container from *reactomen4j* image.

# How it works?

By default it attaches data files inside `$HOME/neo4j` folder. If no data exist, the folder will be created and REACTOME n4j database will be downloaded & deployed from net. 
If the `data` exists container will probe some request the last modification *InstanceEdit* record. If request fails, it will decide that your DB is incorrect, will dump it and redownload new DB from the internet.
