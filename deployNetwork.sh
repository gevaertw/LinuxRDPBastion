#Deploy a basic network with a bastion host


# Define the parameters
PARAMETERS_FILE="parameters.json"

# Read fields from the JSON file
SUBSCRIPTION_ID=$(jq -r '.parameters.subscriptionID.value' "$PARAMETERS_FILE")
LOCATION=$(jq -r '.parameters.location.value' "$PARAMETERS_FILE")
VNET_NAME=$(jq -r '.parameters.vnetName.value' "$PARAMETERS_FILE")
VNET_ADDRESS_PREFIXES=$(jq -r '.parameters.vnetAddressPrefixes.value' "$PARAMETERS_FILE")
VM_SUBNET_NAME=$(jq -r '.parameters.vmSubnetName.value' "$PARAMETERS_FILE")
VM_SUBNET_PREFIX=$(jq -r '.parameters.vmSubnetPrefix.value' "$PARAMETERS_FILE")
BASTION_SUBNET_NAME=$(jq -r '.parameters.bastionSubnetName.value' "$PARAMETERS_FILE")
BASTION_SUBNET_PREFIX=$(jq -r '.parameters.bastionSubnetPrefix.value' "$PARAMETERS_FILE")
NETWORKRG_NAME=$(jq -r '.parameters.networkRGName.value' "$PARAMETERS_FILE")
VMRG_NAME=$(jq -r '.parameters.VMRGName.value' "$PARAMETERS_FILE")
BASTION_HOST_NAME=$(jq -r '.parameters.bastionHostName.value' "$PARAMETERS_FILE")


# Login to Azure,  comment this line if you are already logged in
# az login

# Set the subscription
az account set --subscription $SUBSCRIPTION_ID

# Create resource groups
az group create --name $NETWORKRG_NAME --location $LOCATION
az group create --name $VMRG_NAME --location $LOCATION

# Deploy the Bicep template
az deployment group create \
  --resource-group $NETWORKRG_NAME \
  --template-file network.bicep \
  --parameters \
    location="$LOCATION" \
    vnetName="$VNET_NAME" \
    vnetAddressPrefixes="$VNET_ADDRESS_PREFIXES" \
    vmSubnetName="$VM_SUBNET_NAME" \
    vmSubnetPrefix="$VM_SUBNET_PREFIX" \
    bastionSubnetName="$BASTION_SUBNET_NAME" \
    bastionSubnetPrefix="$BASTION_SUBNET_PREFIX" \
    bastionHostName="$BASTION_HOST_NAME"
    