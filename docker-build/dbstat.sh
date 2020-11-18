#!/bin/sh

exec_cyph="cypher-shell -a bolt://localhost:7687 -u neo4j -p $1 "

echo Physical entity count:
$exec_cyph "match (e:PhysicalEntity) RETURN count(e);"

echo Interaction entity count:
$exec_cyph "match (e:Interaction) RETURN count(e);"

echo Reference entity count:
$exec_cyph "match (e:ReferenceEntity) RETURN count(e);"

echo Print last 10 editions:
$exec_cyph "match (i:InstanceEdit) return i.dbId, i.dateTime, i.displayName order by i.dbId desc limit 10;"
