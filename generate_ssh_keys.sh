#!/usr/bin/env bash

name=${1:-tbdevops}

ssh-keygen -t rsa -N "" -C "SSH Key for Terraform demo" -f "./${name}"