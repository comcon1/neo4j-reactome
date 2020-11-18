docker run \
    --name neoreo-container \
    -p7474:7474 -p7687:7687 \
    -e REANEO_AUTH=neo4j/set_your_password \
    -v $HOME/neo4j/logs:/logs \
    -v $HOME/neo4j/import:/var/lib/neo4j/import \
    -v $HOME/neo4j/plugins:/plugins \
    -v $HOME/neo4j/conf:/conf \
    -v $HOME/neo4j/data:/data \
    --restart unless-stopped \
   reactomen4j:latest

