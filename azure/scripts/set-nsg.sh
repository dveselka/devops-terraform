RG=rg-dave-terraform-test

NSG="$(az network nsg list \
  --resource-group $RG \
  --query '[].name' \
  --output tsv)"

echo "NSG=$NSG"

az network nsg rule list \
  --resource-group $RG \
  --nsg-name $NSG


az network nsg rule list \
  --resource-group $RG \
  --nsg-name $NSG \
  --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
  --output table

az network nsg rule create \
  --resource-group $RG \
  --nsg-name $NSG \
  --name allow-http \
  --protocol tcp \
  --priority 100 \
  --destination-port-ranges 80 \
  --access Allow


az network nsg rule list \
  --resource-group $RG \
  --nsg-name $NSG \
  --query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
  --output table

