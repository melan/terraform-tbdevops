## How to get own public IP address

`curl ifconfig.co`

## Create execution plan
`terraform plan -out terraform.tfplan -var my_ip=$(curl -s ifconfig.co) -var ssh_public_key=$(cat tbdevops.pub)`