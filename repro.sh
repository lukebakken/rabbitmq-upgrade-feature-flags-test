#!/usr/bin/env bash

set -o errexit
set -o nounset

for VER in 7 8 9 10 11
do
    docker_image_name="rabbitmq:3.${VER}-management"
    echo "[INFO] starting '$docker_image_name'"
	docker run --detach --rm --hostname rabbitmq --name feature-flags-test \
        --volume "$PWD/data:/var/lib/rabbitmq" \
        --volume "$PWD/log:/var/log/rabbitmq" \
        --volume "$PWD/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf" \
        "$docker_image_name"
    sleep 5
    set +o errexit
    docker exec feature-flags-test rabbitmqctl await_startup
    docker exec feature-flags-test rabbitmqctl list_feature_flags
    docker exec feature-flags-test rabbitmqctl shutdown
    set -o errexit
    sleep 1
done
