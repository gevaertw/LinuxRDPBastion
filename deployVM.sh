# Set the VM name & type
VMNAME="UGR-WKS03"
VMTYPE="Standard_D4s_v5"
ENABLE_AUTOSHUTDOWN="true" #Set to "true" to enable auto-shutdown, "false" otherwise

# select another coudinit file
VMCLOUDINIT_FILE="simulationpc-cloud-init.yaml"

# Read the content of parameters.json and store each field in a variable
PARAMETERS_FILE="parameters.json"

# Check if the file exists
if [ ! -f "$PARAMETERS_FILE" ]; then
  echo "File $PARAMETERS_FILE does not exist."
  exit 1
fi

# Read fields from the JSON file
TENANT_ID=$(jq -r '.parameters.tenantID.value' "$PARAMETERS_FILE")
SUBSCRIPTION_ID=$(jq -r '.parameters.subscriptionID.value' "$PARAMETERS_FILE")
LOCATION=$(jq -r '.parameters.location.value' "$PARAMETERS_FILE")
ADMIN_USERNAME=$(jq -r '.parameters.adminUsername.value' "$PARAMETERS_FILE")
ADMIN_PASSWORD=$(jq -r '.parameters.adminPassword.value' "$PARAMETERS_FILE")
NETWORKRG_NAME=$(jq -r '.parameters.networkRGName.value' "$PARAMETERS_FILE")
VMRG_NAME=$(jq -r '.parameters.VMRGName.value' "$PARAMETERS_FILE")
VNET_NAME=$(jq -r '.parameters.vnetName.value' "$PARAMETERS_FILE")
VNETADRES_PREFIX=$(jq -r '.parameters.vnetAddressPrefixes.value' "$PARAMETERS_FILE")
VMSUBNET_NAME=$(jq -r '.parameters.vmSubnetName.value' "$PARAMETERS_FILE")
VMSUBNET_PREFIX=$(jq -r '.parameters.vmSubnetPrefix.value' "$PARAMETERS_FILE")
AUTOSHUTDOWN_TIME=$(jq -r '.parameters.autoshutdownTime.value' "$PARAMETERS_FILE")

# Other variables
VMSUBNETNSG_NAME="$VMSUBNET_NAME-nsg"
BASTIONSUBNETNSG_NAME="$BASTIONSUBNET_NAME-nsg"
CUSTOMDATA=$(base64 -w 0 -i $VMCLOUDINIT_FILE)
VMNSG_FILE="vmNSG.json"
BASTIONNSG_FILE="bastionNSG.json"
# Get the resource ID of the existing VM subnet
VMSUBNET_ID=$(az network vnet subnet show --resource-group $NETWORKRG_NAME --vnet-name $VNET_NAME --name $VMSUBNET_NAME --query id --output tsv)

# Deploy the VM using the Bicep template
az deployment group create \
    --resource-group $VMRG_NAME \
    --template-file vm.bicep \
    --parameters \
        vmName=$VMNAME \
        subnetId=$VMSUBNET_ID \
        vmType=$VMTYPE \
        enableAutoShutdown=$ENABLE_AUTOSHUTDOWN \
        adminUsername=$ADMIN_USERNAME \
        adminPassword=$ADMIN_PASSWORD \
        customData=$CUSTOMDATA
