# Multi-Service Node.js E-commerce on AWS (Terraform + Docker)

**Author:** Saurabh Bhatnagar

Four backend services (user, products, orders, cart) and one frontend, containerized with Docker,
published to Docker Hub and deployed on an AWS EC2 instance provisioned entirely with Terraform.

## Architecture
Internet -> Internet Gateway -> VPC (10.0.0.0/16) -> public subnet (10.0.1.0/24) -> EC2 (Ubuntu 22.04)
running five containers on a Docker network `ecom-net`.

| Service | Container port | Host port | Exposure |
|---|---|---|---|
| frontend | 3000 | 80 | Public |
| user-service | 3001 | 3001 | Internal (security group only) |
| products-service | 3002 | 3002 | Internal |
| orders-service | 3003 | 3003 | Internal |
| cart-service | 3004 | 3004 | Internal |

## Repository structure
```
.
├── services/            # 4 backends + frontend (server.js, Dockerfile, package.json)
├── terraform/           # providers, variables, main, outputs, user-data template
├── docs/                # Full assignment report (Word)
├── screenshots/         # Evidence screenshots (add yours here)
├── docker-compose.yml   # Local testing
├── build_and_push.sh    # Build, tag and push all images
└── README.md
```

## Prerequisites
Docker, Terraform >= 1.5, AWS CLI (configured with `aws configure`), a Docker Hub account.

## Usage
```bash
# 1. Test locally
docker compose up --build -d
curl localhost:3001
# open http://localhost:3000
docker compose down

# 2. Build and push images (make the Docker Hub repos public)
docker login
chmod +x build_and_push.sh
./build_and_push.sh <dockerhub-username>

# 3. Deploy to AWS
cd terraform
cp terraform.tfvars.example terraform.tfvars    # set dockerhub_username
terraform init
terraform validate
terraform plan
terraform apply

# 4. Open the frontend_url output after 2-3 minutes
terraform output frontend_url

# 5. Clean up
terraform destroy
```

## Verification on the instance
```bash
ssh -i <key>.pem ubuntu@<public-ip>
docker ps
curl localhost:3001
sudo tail -n 60 /var/log/user-data.log
```

## Screenshots
See the [screenshots](screenshots/) folder and the report in [docs](docs/).

## License
MIT
# Ecommerce-terraform-docker-Skill-Test-3
