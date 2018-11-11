#!/usr/bin/env bash

wget -O /tmp/install_dd.sh https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh
chmod +x /tmp/install_dd.sh
DD_API_KEY=${DD_API_KEY} /tmp/install_dd.sh
rm -f /tmp/install_dd.sh
