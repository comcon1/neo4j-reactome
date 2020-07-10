docker run \
    --name neoreo-container \
    -d \
    -p7474:7474 -p443:7687 \
    -v $HOME/neo4j/logs:/logs \
    -v $HOME/neo4j/import:/var/lib/neo4j/import \
    -v $HOME/neo4j/plugins:/plugins \
    -v $HOME/neo4j/conf:/conf \
    --restart unless-stopped \
   reactomen4j

