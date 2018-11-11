## How to get own public IP address

`curl ifconfig.co`

## Create execution plan
```bash
    terraform plan -out terraform.tfplan \
        -var "my_ip=$(curl -s ifconfig.co)" \
        -var "ssh_public_key=$(cat tbdevops.pub)" \
        -var "ssh_private_key_file=`pwd`/tbdevops" \
        -var "dd_api_key=$(cat dd-api-key)" \
        -var "dd_app_key=$(cat dd-app-key)"
```

## Apply the plan
`terraform apply "terraform.tfplan"`

## Later destroy everything
```bash
    terraform destroy \
        -var "my_ip=$(curl -s ifconfig.co)" \
        -var "ssh_public_key=$(cat tbdevops.pub)" \
        -var "ssh_private_key_file=`pwd`/tbdevops" \
        -var "dd_api_key=$(cat dd-api-key)" \
        -var "dd_app_key=$(cat dd-app-key)"
```

