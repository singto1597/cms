#!/usr/bin/env bash
set -x

GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD | tr A-Z a-z)
PROJECT_NAME="cms-$GIT_BRANCH_NAME"
COMPOSE_FILE="docker/docker-compose.dev.yml"


echo "Starting containers in detached mode: $PROJECT_NAME"
docker compose -p "$PROJECT_NAME" -f "$COMPOSE_FILE" up -d --build

sleep 1

echo "Attaching to devcms container..."
docker compose -p "$PROJECT_NAME" -f "$COMPOSE_FILE" exec devcms bash
