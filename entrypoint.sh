#!/bin/bash
registration_url="https://api.github.com/repos/obynodavid12/hosted-runners/actions/runners/registration-token"
echo "Requesting registration URL at '${registration_url}'"

payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PERSONAL_TOKEN}" ${registration_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)


./config.sh \
    --name $(hostname) \
    --token ${RUNNER_TOKEN}
    --url https://github.com/obynodavid12/hosted-runners \
    --work "workDir" \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"

}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &
 wait $!

