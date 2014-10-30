#!/bin/bash

MICA_HOST=localhost
MICA_PORT=8845

echo "Creating studies..."
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/studies --content-type "application/json" < seed/mica/study-CLSA.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/studies --content-type "application/json" < seed/mica/study-CLS.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/studies --content-type "application/json" < seed/mica/study-LBLS.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/studies --content-type "application/json" < seed/mica/study-ULSAM.json

echo "Publishing studies..."
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study/clsa/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study/cls/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study/lbls/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study/ulsam/_publish

echo "Creating networks..."
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/networks --content-type "application/json" < seed/mica/network-BBMRI.json

echo "Publishing networks..."
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/network/bbmri/_publish

echo "Creating datasets..."
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-FNAC.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-WAVE1.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-WAVE2.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-WAVE3.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-WAVE4.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-ULSAM50.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-ULSAM60.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-ULSAM70.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-ULSAM77.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-ULSAM82.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-ULSAM88.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-1978.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-1981.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-1994.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-1997.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-2000.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-2003.json
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m POST /draft/study-datasets --content-type "application/json" < seed/mica/study-dataset-2008.json

echo "Publishing datasets..."
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/fnac/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/wave1/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/wave2/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/wave3/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/wave4/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/ulsam50/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/ulsam60/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/ulsam70/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/ulsam77/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/ulsam82/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/ulsam88/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/1978/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/1981/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/1994/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/1997/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/2000/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/2003/_publish
mica rest -mk https://$MICA_HOST:$MICA_PORT -u administrator -p password -m PUT /draft/study-dataset/2008/_publish
