#!/bin/sh

# Ensure we have all the environment variables set

set -eu -o pipefail
echo "\033[92mStaker:\033[0m $STAKER"
echo "\033[92mStaker controller:\033[0m $STAKER_CONTROLLER"
echo "\033[92mRewards collector:\033[0m $REWARDS_COLLECTOR"
echo "\033[92mGrantee:\033[0m $GRANTEE"
echo "\033[92mStaking Contract:\033[0m $CONTRACT"
echo "\033[92mSource Channel:\033[0m $SOURCE_CHANNEL"

# Create staker_tx.json

echo
echo "\033[92mCreating staker_tx.json\033[0m"

GRANTER=$STAKER GRANTEE=$GRANTEE SOURCE_CHANNEL=$SOURCE_CHANNEL RECEIVER=$CONTRACT \
  envsubst < transfer_authz_template.json > staker_tx_10.json
printf "."

jq -s '{
  "body": {
    "messages": (map(.body.messages) | add)
  },
  "auth_info": {
    "signer_infos": [],
    "fee": {
      "amount": [
        {
          "denom": "ubbn",
          "amount": "15000"
        }
      ],
      "gas_limit": 1000000,
      "payer": "",
      "granter": ""
    },
    "tip": null
  },
  "signatures": []
}' staker_tx_*.json > staker_tx.json
printf "."

rm staker_tx_*.json
printf "."

echo
echo "\033[92mSuccessfully created staker_tx.json!\033[0m"

# Create rewards_collector_tx.json

echo
echo "\033[92mCreating rewards_collector_tx.json\033[0m"

GRANTER=$REWARDS_COLLECTOR GRANTEE=$GRANTEE SOURCE_CHANNEL=$SOURCE_CHANNEL RECEIVER=$CONTRACT \
  envsubst < transfer_authz_template.json > rewards_collector_tx.json
printf "."

echo
echo "\033[92mSuccessfully created rewards_collector_tx.json!\033[0m"
