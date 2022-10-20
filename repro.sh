#!/usr/bin/env bash

set -o xtrace
set -o errexit
set -o nounset

sudo chown -R 999:999 log data

declare -ri final_ver=11

for rmq_ver in 7 8 9 10 "$final_ver"
do
    docker_image_name="rabbitmq:3.${rmq_ver}-management"
    echo "[INFO] starting '$docker_image_name'"
    docker_cmd='docker run --detach'
    if (( rmq_ver == final_ver ))
    then
        # Don't detach since this should show the issue
        docker_cmd='docker run'
    fi
    $docker_cmd --rm --hostname rabbitmq --name feature-flags-test \
        --volume "$PWD/data:/var/lib/rabbitmq" \
        --volume "$PWD/log:/var/log/rabbitmq" \
        --volume "$PWD/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf" \
        "$docker_image_name"
    if (( rmq_ver == final_ver ))
    then
        echo '[INFO] you should see the feature flags error'
    else
        sleep 5
        set +o errexit
        docker exec feature-flags-test rabbitmqctl await_startup
        docker exec feature-flags-test rabbitmqctl list_feature_flags
        docker exec feature-flags-test rabbitmqctl shutdown
        set -o errexit
        sleep 1
    fi
done
