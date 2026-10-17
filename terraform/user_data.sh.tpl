#!/bin/bash
# Runs once at first boot. Log: /var/log/user-data.log
exec > >(tee /var/log/user-data.log) 2>&1
set -x

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y docker.io
systemctl enable --now docker

DH="${dockerhub_username}"
TAG="${image_tag}"

# User-defined network so containers resolve each other by name
docker network create ecom-net || true

# Pull all five images
for svc in user-service products-service orders-service cart-service frontend; do
  docker pull "$DH/$svc:$TAG"
done

# Backends (published on host ports for local verification; SG blocks them from the internet)
docker run -d --name user-service     --network ecom-net --restart always -p 3001:3001 "$DH/user-service:$TAG"
docker run -d --name products-service --network ecom-net --restart always -p 3002:3002 "$DH/products-service:$TAG"
docker run -d --name orders-service   --network ecom-net --restart always -p 3003:3003 "$DH/orders-service:$TAG"
docker run -d --name cart-service     --network ecom-net --restart always -p 3004:3004 "$DH/cart-service:$TAG"

# Frontend: host port 80 -> container port 3000
docker run -d --name frontend --network ecom-net --restart always -p 80:3000 "$DH/frontend:$TAG"

docker ps
echo "Deployment complete"
