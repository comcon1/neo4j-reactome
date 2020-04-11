#!/bin/sh
echo Physical entity count:
echo 'match (e:PhysicalEntity) RETURN count(e);' | \
	cypher-shell -a bolt://localhost:7687 -u neo4j -p neo4j-emotcaer
echo Interaction entity count:
echo 'match (e:Interaction) RETURN count(e);' | \
	cypher-shell -a bolt://localhost:7687 -u neo4j -p neo4j-emotcaer
echo Reference entity count:
echo 'match (e:ReferenceEntity) RETURN count(e);' | \
	cypher-shell -a bolt://localhost:7687 -u neo4j -p neo4j-emotcaer
echo Print last 10 editions:
echo 'match (i:InstanceEdit) return i.dbId, i.dateTime, i.displayName order by i.dbId desc limit 10;' | \
	cypher-shell -a bolt://localhost:7687 -u neo4j -p neo4j-emotcaer
