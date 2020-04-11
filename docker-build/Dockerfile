FROM neo4j:3.5 

ARG REACTOME_URI=https://reactome.org/download/current/reactome.graphdb.tgz 

COPY --chown=neo4j:neo4j dbstat.sh .

# download and prepare reactome archive
# deployment reactome database
# start-stop DB server for initialization
RUN \
    wget ${REACTOME_URI} && \
    mkdir _archive && cd _archive && \
    tar xzvf ../reactome.graphdb.tgz --strip-components=1 && \
    rm -f ../reactome.graphdb.tgz && \
    tar czvf ../reactome.graph.tgz * --remove-files && \
    cd .. && rmdir _archive && \
    cp -ra /data /data_ && \
    rm "${NEO4J_HOME}"/data && \
    ln -s /data_ "${NEO4J_HOME}"/data && \
    apt-get -y update && apt-get -y upgrade && \
    gosu neo4j:neo4j neo4j start && \
    sleep 10 && \
    gosu neo4j:neo4j neo4j stop && \
    gosu neo4j:neo4j neo4j-admin load --from=./reactome.graph.tgz --force && \
    rm -f ./reactome.graph.tgz && \
    gosu neo4j:neo4j neo4j start && \
    echo "== Wait 20 sec for reindexing! ==" && \
    sleep 20 && \
    echo "CALL dbms.changePassword('neo4j-emotcaer');" | \
       gosu neo4j:neo4j cypher-shell -a bolt://localhost:7687 -u neo4j -p neo4j && \
    echo "== Wait 20 sec for reindexing! ==" && \
    sleep 60 && \
    echo "== Showing the stats! ==" && \
    gosu neo4j:neo4j ./dbstat.sh && \
    gosu neo4j:neo4j neo4j stop
   
# EXPOSE, ENTRYPOING, and EXEC are inherited
# see for details
# https://github.com/neo4j/docker-neo4j-publish/tree/master/3.5.17/community
