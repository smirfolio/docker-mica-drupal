#!/bin/bash

OPAL_HOST=localhost
OPAL_PORT=8843

echo "Waiting for Opal to be ready..."
while [ `opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m GET /system/databases | grep -ch "mongodb"` -eq 0 ]
do
	echo -n "."
	sleep 5
done

echo "Creating projects..."
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m POST /projects --content-type "application/json" < ./seed/opal/project-mica.json
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m POST /projects --content-type "application/json" < ./seed/opal/project-CLSA.json
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m POST /projects --content-type "application/json" < ./seed/opal/project-CLS.json
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m POST /projects --content-type "application/json" < ./seed/opal/project-LBLS.json
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m POST /projects --content-type "application/json" < ./seed/opal/project-ULSAM.json

echo "Uploading data files..."
opal file -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -up ./seed/opal/data-mica.zip /tmp
opal file -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -up ./seed/opal/data-CLS.zip /tmp
opal file -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -up ./seed/opal/data-CLSA.zip /tmp
opal file -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -up ./seed/opal/data-ULSAM.zip /tmp
opal file -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -up ./seed/opal/data-LBLS.zip /tmp

echo "Importing data files..."
opal import-xml -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -pa /tmp/data-mica.zip -d mica
while [ `opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ]
do echo -n "."; sleep 5; done; echo "."

opal import-xml -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -pa /tmp/data-CLS.zip -d CLS
while [ `opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ]
do echo -n "."; sleep 5; done; echo "."

opal import-xml -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -pa /tmp/data-CLSA.zip -d CLSA
while [ `opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ]
do echo -n "."; sleep 5; done; echo "."

opal import-xml -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -pa /tmp/data-ULSAM.zip -d ULSAM
while [ `opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ]
do echo -n "."; sleep 5; done; echo "."

opal import-xml -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -pa /tmp/data-LBLS.zip -d LBLS
while [ `opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ]
do echo -n "."; sleep 5; done; echo "."

echo "Indexing data..."
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/mica/table/SMK/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/mica/table/HOP/index

opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLS/table/Wave1/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLS/table/Wave2/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLS/table/Wave3/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLS/table/Wave4/index

opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLSA/table/SMK/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLSA/table/HOP/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/CLSA/table/FNAC/index

opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/1978/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/1981/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/1994/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/1997/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/2000/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/2003/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/LBLS/table/2008/index

opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/ULSAM/table/ULSAM50/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/ULSAM/table/ULSAM60/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/ULSAM/table/ULSAM70/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/ULSAM/table/ULSAM77/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/ULSAM/table/ULSAM82/index
opal rest -o https://$OPAL_HOST:$OPAL_PORT -u administrator -p password -m PUT /datasource/ULSAM/table/ULSAM88/index
