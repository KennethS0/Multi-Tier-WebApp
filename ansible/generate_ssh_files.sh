#!/bin/bash

# Passed parameters in CMD line
INFRA_DIR="${1}"
SSH_KEY_PATH="${2}"

SSH_CONFIG_FILE="ssh_bastion_to_app"

# Get important information
cd $INFRA_DIR
BASTION_IP=$(terraform output -json web_public_ips | jq -r '.[0]')
APP_IPS=$(terraform output -json app_private_ips | jq -r '.[]')
cd - >/dev/null

cat > $SSH_CONFIG_FILE <<EOF

Host bastion
    HostName ${BASTION_IP}
    User ubuntu
    IdentityFile ${SSH_KEY_PATH}
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null

Host 10.*
    User ubuntu
    IdentityFile ${SSH_KEY_PATH}
    ProxyJump bastion
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOF

chmod 600 "$SSH_CONFIG_FILE"