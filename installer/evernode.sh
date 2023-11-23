#!/bin/bash
# Evernode host latest version installer

export NETWORK="${NETWORK:-devnet}"
export NO_DOMAIN="${NO_DOMAIN:-0}"
export SKIP_SYSREQ="${SKIP_SYSREQ:-0}"

[ -z $VERSION ] && VERSION="latest"
repository="https://api.github.com/repos/kithminisg/simulink/releases"

if [ "$VERSION" = "latest" ]; then
    release_data=$(curl -s "$repository/latest")
else
    release_data=$(curl -s $repository)
fi

# Check if the release is found.
[ -z "$release_data" ] || [ "$(echo $release_data | jq -r 'if type=="array" then "yes" else '.message' end') << "$realease_data"" = "Not Found" ] && echo "Sashimono $VERSION not found." && exit 1

# Fetch the release url
if [ "$VERSION" = "latest" ]; then
    VERSION=$(echo $release_data | jq -r '.tag_name')
    setup=$(echo $release_data | jq -r '.assets[] | select(.name == "setup.sh").browser_download_url')
else
    setup=$(echo $release_data | jq -r '.[] | select(.tag_name == '\"$VERSION\"') | .assets[] |  select(.name == "setup.sh").browser_download_url')
fi

# Check if the release is found.
[ -z "$setup" ] && echo "Sashimono $VERSION not found." && exit 1

echo "Found Sashimono $VERSION..."

# Exucute the setup
if [ -n "$NEW_GOVERNOR" ]; then
    curl -fsSL $setup | cat | sudo OVERRIDE_EVERNODE_GOVERNOR_ADDRESS=$NEW_GOVERNOR NETWORK=$NETWORK NO_DOMAIN=$NO_DOMAIN SKIP_SYSREQ=$SKIP_SYSREQ bash -s ${@}
else
    curl -fsSL $setup | cat | sudo NETWORK=$NETWORK NO_DOMAIN=$NO_DOMAIN SKIP_SYSREQ=$SKIP_SYSREQ bash -s ${@}
fi

