# Multi-Service Node.js E-commerce on AWS (Terraform + Docker)

**Author:** Saurabh Bhatnagar

Four backend services (user, products, orders, cart) and one frontend, containerized with Docker,
published to Docker Hub and deployed on an AWS EC2 instance provisioned entirely with Terraform.

## Architecture

```
Internet --> Internet Gateway --> VPC (10.0.0.0/16)
                                   └── Public subnet (10.0.1.0/24)
                                        └── Security group
                                             └── EC2 (Ubuntu 22.04, Docker installed by user-data)
                                                  └── Docker network: ecom-net
                                                       ├── frontend          (80 -> 3000)
                                                       ├── user-service      (3001)
                                                       ├── products-service  (3002)
                                                       ├── orders-service    (3003)
                                                       └── cart-service      (3004)
```

| Service | Container port | Host port | Exposure |
|---|---|---|---|
| frontend | 3000 | 80 | Public |
| user-service | 3001 | 3001 | Internal (security group only) |
| products-service | 3002 | 3002 | Internal |
| orders-service | 3003 | 3003 | Internal |
| cart-service | 3004 | 3004 | Internal |

The frontend shows **"Frontend is Live"** and the live status of all four backends.

## Repository structure

```
.
├── services/            # 4 backends + frontend (server.js, Dockerfile, package.json)
├── terraform/           # providers, variables, main, outputs, user-data template
├── screenshots/         # Evidence screenshots
├── docker-compose.yml   # Local testing
├── build_and_push.sh    # Build, tag and push all images
├── LICENSE
└── README.md
```

## Prerequisites

- Docker
- Terraform 1.5 or later
- AWS CLI, configured with `aws configure` (use an IAM user, not root)
- A Docker Hub account (images must be public)
- Optional: an EC2 key pair for SSH access

## Usage

### 1. Test locally

```bash
docker compose up --build -d
curl localhost:3001
# open http://localhost:3000
docker compose down
```

### 2. Build and push the images

Make each Docker Hub repository public.

```bash
docker login
chmod +x build_and_push.sh
./build_and_push.sh <dockerhub-username>
```

### 3. Deploy to AWS

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars    # set dockerhub_username
terraform init
terraform validate
terraform plan
terraform apply
```

`terraform.tfvars` example:

```hcl
dockerhub_username = "<your-dockerhub-username>"
aws_region         = "ap-south-1"
key_name           = "<your-key-pair-name>"      # optional, for SSH
allowed_ssh_cidr   = "<your-public-ip>/32"       # optional, limits SSH
```

### 4. Open the application

Wait 2-3 minutes after `apply` while the instance installs Docker and pulls the images, then:

```bash
terraform output frontend_url
```

Open the printed URL in a browser.

### 5. Clean up

```bash
terraform destroy
```

## Verification on the instance

```bash
ssh -i ~/.ssh/<key-name>.pem ubuntu@<public-ip>
docker ps
curl localhost:3001
curl localhost:3004/health
sudo tail -n 60 /var/log/user-data.log
```

## Terraform resources

| Resource | Purpose |
|---|---|
| `aws_vpc` | VPC 10.0.0.0/16 |
| `aws_internet_gateway` | Internet access for the VPC |
| `aws_subnet` | Public subnet 10.0.1.0/24 |
| `aws_route_table` + association | Route 0.0.0.0/0 through the internet gateway |
| `aws_security_group` | 80 from anywhere, 22 from a chosen CIDR, 3001-3004 from the group itself |
| `aws_instance` | Ubuntu 22.04 EC2 with user-data that installs Docker and runs the five containers |

## Security notes

- Never commit `*.pem` keys, `terraform.tfstate` or `terraform.tfvars` (all are listed in `.gitignore`).
- Backend ports 3001-3004 are not reachable from the internet, only from inside the security group.
- Restrict `allowed_ssh_cidr` to your own IP address.

## Screenshots

See the [screenshots](screenshots/) folder.

## License

MIT
