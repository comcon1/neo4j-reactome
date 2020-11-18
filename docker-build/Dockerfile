FROM neo4j:3.5 

ENV REACTOME_URI=https://reactome.org/download/current/reactome.graphdb.tgz 

# ${NEO4J_HOME}/bin is inside PATH in parent container

COPY --chown=neo4j:neo4j dbstat.sh ${NEO4J_HOME}/bin
COPY --chown=neo4j:neo4j rearun.sh ${NEO4J_HOME}/bin

CMD [ "rearun.sh" ]
   
# EXPOSE, ENTRYPOING are inherited
# see for details
# https://github.com/neo4j/docker-neo4j-publish/tree/master/3.5.24/community
