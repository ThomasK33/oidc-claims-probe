#!/usr/bin/env bash
# Requests a GitHub OIDC token for a throwaway audience and prints only its
# decoded payload. The token itself (with signature) is never printed or stored.
set -euo pipefail
label="$1"
aud="https://oidc-claims-probe.invalid"
resp=$(curl -sS -H "Authorization: bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL&audience=$aud")
payload=$(jq -r .value <<<"$resp" | cut -d. -f2 | tr '_-' '/+')
while [ $(( ${#payload} % 4 )) -ne 0 ]; do payload="$payload="; done
mkdir -p claims
base64 -d <<<"$payload" | jq --arg label "$label" '{label: $label} + .' > "claims/$label.json"
jq -c '{label, sub, ref, event_name, environment, job_workflow_ref, workflow_ref, ref_type, head_ref, base_ref, ref_protected, exp_minus_iat: (.exp - .iat)}' "claims/$label.json"
