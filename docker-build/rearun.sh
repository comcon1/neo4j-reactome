#!/bin/bash

tempPWD=`tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1`

# ----------------------------------------------
# wait until some phrase appear in the file
# usage: waitFile file.log "the phrase for stop"
# ----------------------------------------------
function waitFile {
 fileName=$1
 stopPhrase=$2
 stopv=1
 until [ $stopv = 0 ];
 do
   echo "Waiting for \"${stopPhrase}\" in ${fileName} .."
   sleep 2
   grep "${stopPhrase}" ${fileName} > /dev/null
   stopv=$?
 done
 echo "\"${stopPhrase}\" appeared."
}

# ----------------------------------------------
# main function before server start
# ----------------------------------------------
function checkFirstRun {

 needDownloadFlag=0

 if [ -d "/data/databases" ]; then
   echo "Database found. Verifying it.."
   echo "" > /logs/neo4j.log
   neo4j start
   waitFile /logs/neo4j.log "INFO  Remote interface available at"

   lastDate=`cypher-shell -a bolt://localhost:7687 -u neo4j -p ${tempPWD} \
--format plain "match (c:InstanceEdit) return max(c.dateTime);" | tail -n1`
   neo4j stop

   if [ "$lastDate" = "NULL" ]; then
       echo "Database found in /data is not reactome."
       needDownloadFlag=1
   else
       echo >&2 "Reactome Database found in /data. Last record: ${lastDate}"
       echo >&2 "To update DB version, please deploy this container with empty /data."
       echo "" > /logs/neo4j.log
   fi # lastDate == NULL
 else
   echo "Database in your /data directory was not found. Initializing.."
   echo "" > /logs/neo4j.log
   neo4j start
   waitFile /logs/neo4j.log "INFO  Remote interface available at"
   neo4j stop
   echo "Database initialized."
   needDownloadFlag=1
 fi # check for /data/dabases   

 # verify if it is required to download & deploy Reactome Database
 if [ $needDownloadFlag = 1 ]; then 
   echo "Download Reactome DB from the web & archive old data."
   echo "-------------------------------------"
   echo "Download current DB."
   cd
   wget ${REACTOME_URI}
   mkdir _archive
   cd _archive
   tar xzvf ../reactome.graphdb.tgz --strip-components=1
   rm -f ../reactome.graphdb.tgz
   tar czvf ../reactome.graph.tgz * --remove-files
   neo4j-admin load --from=../reactome.graph.tgz --force
   rm -f ../reactome.graph.tgz
   # save old data
   echo "Archiving old.."
   cp -rva /data/* .
   cd
   echo "Database has been deployed."
   echo "-------------------------------------"
 fi # needDownloadFlag
 
 # start server to first "calibration" of the DB
 # and/or for simple statistics output
 echo "" > /logs/neo4j.log
 neo4j start
 waitFile /logs/neo4j.log "INFO  Remote interface available at"
 dbstat.sh ${tempPWD}
 neo4j stop

 return 0
} # end function checkFirstRun

# ----------------------------------------------
# set pwd from REANEO_AUTH
# or leave it as generated temporary
# ----------------------------------------------
function setSomePassword() {
    # for community only user *neo4j* is allowed
    if [[ "${REANEO_AUTH:-}" == neo4j/* ]]; then
        password="${REANEO_AUTH#neo4j/}"
        if [ "${password}" == "neo4j" ]; then
            echo >&2 "Invalid value for password. It cannot be 'neo4j', which is the default."
            return 1
        fi
        rm -f /data/dbms/auth*
        neo4j-admin set-initial-password "${password}"
        tempPWD="${password}"
        echo "Password has been set to: ${tempPWD}"

	elif [ -z "${REANEO_AUTH:-}" ]; then
		echo "Environmental variable REANEO_AUTH was not set."
		echo "The randomly generated password was set: "
		echo "          --- ${tempPWD} ---             "
        rm -f /data/dbms/auth*
        neo4j-admin set-initial-password "${tempPWD}"
		return 0
	else
        echo >&2 "Invalid value for REANEO_AUTH: '${REANEO_AUTH}'"
        return 1
    fi
} #


# MAIN BODY

setSomePassword

checkFirstRun

neo4j console

