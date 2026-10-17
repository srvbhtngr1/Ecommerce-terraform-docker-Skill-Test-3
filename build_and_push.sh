#!/usr/bin/env bash
# Usage: ./build_and_push.sh <dockerhub-username> [tag]
set -euo pipefail
USER_NAME="${1:?Usage: $0 <dockerhub-username> [tag]}"
TAG="${2:-latest}"
for svc in user-service products-service orders-service cart-service frontend; do
  echo "==> Building and pushing $USER_NAME/$svc:$TAG"
  docker build -t "$USER_NAME/$svc:$TAG" "services/$svc"
  docker push "$USER_NAME/$svc:$TAG"
done
echo "All images pushed. Make each repo public on Docker Hub."
