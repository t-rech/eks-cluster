#!/bin/bash

set -eu

sed -i -e "s|<AUTH0_DOMAIN>|${AUTH0_DOMAIN}|" auth0/config.json
sed -i -e "s|<CLIENT_ID>|${AUTH0_CLIENT_ID}|" auth0/config.json
sed -i -e "s|<CLIENT_SECRET>|${AUTH0_CLIENT_SECRET}|" auth0/config.json
