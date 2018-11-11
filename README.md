# Terraform demo for [TBDevOps meetup](https://www.meetup.com/TBDevOps/events/mztfcqyxpbzb/)

This is a demo project to show terraform capabilities as well as different features of the tool.

Slides for the presentation are [available at Google Slides](http://bit.ly/terraform-tbdevops)

There are 3 modules in the project:

* modules/datadog - setups a dashboard at DataDog
* modules/peering - establishes peering connection between 2 VPCs
* modules/vpc - creates a VPC with a subnet in each AZ and with an instance in each of the subnets

Each of the modules shows us different features:

## modules/vpc

The module is an example of shared functionality when the same configuration is applied twice to two different 
AWS regions. Each time it adjusts to parameters of the region: with default settings it creates 3 subnets and 3 instances 
in US-East-2 and only 2 subnets and 2 instances in US-West-1. This happens because the US-East-2 region has 3 AZs and US-West-1
has only 2 AZs. 

When the module creates an instance is calls `file` and `remote-exec` provisioners to install and configure DataDog agent
on each instance

The module uses a `data.template_file` to inject DataDog api key into the install file.

## module/peering

This module is interesting because it runs commands in 2 different regions: names of the regions are passed as variables 
to the module and internally the names are converted into providers (`providers.tf` file). Each resource and data source
in the module is called with `provider = ...` parameter to specify in what region the resource should be applied.

## module/datadog

This module integrates AWS and DataDog, it creates providers to both of the services and uses the providers for different 
resources. 

# How to deploy the infrastructure

## Prerequisites

* You will need an account on AWS
* You will need an account on DataDog

While I worked on this code I spent about 18¢ on both of the services, so it should not be very expensive.  

## Files you'll need to deploy/destroy the environment:

* SSH Keys: `tbdevops` and `tbdevops.pub` - run `./generate_ssh_keys.sh` to generate the files
* DataDog API key: `dd-api-key`. The code will be listed on the Agent setup stage when you create a new account with DD, 
or you can find/create one at DataDog -> Integration -> APIs page
* DataDog APP key: `dd-app-key`. You can find/create one at DataDog -> Integration -> APIs page
* DataDog ExternalId: `dd-external-id`. Enable integration with AWS and the code will be on the configuration page. 

## Download all modules, providers, provisioners and initialize terraform environment

```bash
    terraform init
```

## Create execution plan
```bash
    terraform plan -out terraform.tfplan \
        -var "my_ip=$(curl -s ifconfig.co)" \
        -var "ssh_public_key=$(cat tbdevops.pub)" \
        -var "ssh_private_key_file=`pwd`/tbdevops" \
        -var "dd_api_key=$(cat dd-api-key)" \
        -var "dd_app_key=$(cat dd-app-key)" \
        -var "dd_external_id=$(cat dd-external-id)"
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
        -var "dd_app_key=$(cat dd-app-key)" \
        -var "dd_external_id=$(cat dd-external-id)"
```

# Good to know

* To get own public IP address: `curl ifconfig.co`

