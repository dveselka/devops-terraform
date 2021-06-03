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

