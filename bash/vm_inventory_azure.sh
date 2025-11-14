#!/bin/bash
set -euo pipefail

OUTPUT="vm_inventory.yaml"
EXCLUDE_SUBS=(
  "example-sub-id" # sandbox
)


echo "Generating VM inventory..."
echo "vms:" > "$OUTPUT"

SUBS=$(az account list --query "[].id" -o tsv)

for SUB in $SUBS; do
    # Skip excluded subscriptions
    if [[ " ${EXCLUDE_SUBS[*]} " == *" $SUB "* ]]; then
        echo "Skipping excluded subscription: $SUB"
        continue
    fi

    SUB_NAME=$(az account show --subscription "$SUB" --query "name" -o tsv)
    echo "Scanning subscription: $SUB ($SUB_NAME)"
    az account set --subscription "$SUB"

    VMS_JSON=$(az vm list -d -o json)

    echo "$VMS_JSON" | jq -c '.[]' | while read -r VM; do
        PUBLISHER=$(echo "$VM" | jq -r '.storageProfile.imageReference.publisher // empty')

        # Skip Databricks VMs
        if [[ "$PUBLISHER" == "AzureDatabricks" ]]; then
            echo "Skipping Databricks VM: $(echo "$VM" | jq -r '.name')"
            continue
        fi

        NAME=$(echo "$VM" | jq -r '.name')
        RG=$(echo "$VM" | jq -r '.resourceGroup')
        LOCATION=$(echo "$VM" | jq -r '.location')
        ID=$(echo "$VM" | jq -r '.id')
        OS_TYPE=$(echo "$VM" | jq -r 'if .storageProfile.osDisk.osType=="Linux" then "linux" else "windows" end')

        # Append to YAML including subscription name
        cat >> "$OUTPUT" <<EOF
  - name: "$NAME"
    os: "$OS_TYPE"
    subscription_id: "$SUB"
    subscription_name: "$SUB_NAME"
    resource_group: "$RG"
    location: "$LOCATION"
    id: "$ID"
EOF
    done
done


echo "Done! VM inventory written to: $OUTPUT"
