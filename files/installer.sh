#!/bin/bash
# This script is also used to install evernode CLI via retrieving the latest release setup tool.
# Evernode host setup tool to manage Sashimono installation and host registration.
# usage: ./installer.sh

# surrounding braces  are needed make the whole script to be buffered on client before execution.
{

export NETWORK="${NETWORK:-testnet}"
export NO_DOMAIN="${NO_DOMAIN:-0}"
export SKIP_SYSREQ="${SKIP_SYSREQ:-0}"

repo_owner="kithminisg"
repo_name="simulink"
desired_asset_name="setup.sh"
release_url="https://api.github.com/repos/$repo_owner/$repo_name/releases/latest"

# Fetch the latest release information using curl and parse it with jq
release_info=$(curl -s $release_url)
download_url=$(echo $release_info | jq -r --arg desired_asset "$desired_asset_name" '.assets[] | select(.name == $desired_asset) | .browser_download_url')


# TODO REMOVE NO_DOMAIN
#curl -fsSL $download_url | cat | sudo bash -s install

curl -fsSL $download_url | cat | sudo NETWORK=$NETWORK NO_DOMAIN=$NO_DOMAIN SKIP_SYSREQ=$SKIP_SYSREQ bash -s install

# surrounding braces  are needed make the whole script to be buffered on client before execution.
}
