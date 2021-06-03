export IPADDRESS="$(az vm list-ip-addresses \
  --resource-group rg-dave-terraform-test \
  --name dave-terraform-test \
  --query "[].virtualMachine.network.publicIpAddresses[*].ipAddress" \
  --output tsv)"
