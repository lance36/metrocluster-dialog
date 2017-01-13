#!/bin/bash

# Questo script verifica la possibilità di eseguire lo spegnimento del sito di Scalo Prenestino,
# e ritorna un exit code come da tabella:
#
# Exit codes:
# 	0 - READY
#	1 - In Progress (TODO)
# 	2 - COMPLETED
# 	3 - NOT READY

#Check Local and Remote Cluster:
OUTPUT="$(ssh NETAPP8020A -l admin "metrocluster show"|grep "Local:")"
OUTPUTSP="$(ssh NETAPP8020A -l admin "metrocluster show"|grep "Remote:")"
echo "$OUTPUT"
echo "$OUTPUTSP"

#Return exit code based on local and remote status:
case $OUTPUT in
        *switchover*)
                echo "COMPLETED"
				exit 2;;
        *normal*)
				if [[ $OUTPUTSP = *normal* ]]; then
					echo "READY";
					exit 0
				else
					echo "NOT READY"
					exit 3;
				fi;;

        *)
                echo "NOT READY"
				exit 3;;
esac

