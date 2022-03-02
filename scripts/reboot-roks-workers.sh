#!/bin/sh

REGION="$1"
RESOURCE_GROUP="$2"

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY environment variable must be set"
  exit 1
fi

ibmcloud login --apikey ${IBMCLOUD_API_KEY} -r ${REGION} -g ${RESOURCE_GROUP} -q

# do a rolling action of all workers
echo "Performing rolling reboot of workers, 5 min wait after each action"
for WORKER in $(ibmcloud cs worker ls --cluster ${CLUSTER} | grep kube | cut -d' ' -f1); do
    echo "rebooting $WORKER..."
    ibmcloud cs worker reboot -f --skip-master-health --worker $WORKER --cluster ${CLUSTER};
    sleep 300;
done