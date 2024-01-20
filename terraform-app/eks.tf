data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" { }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}


module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version = "17.10.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.26"
  cluster_endpoint_private_access = true 

  subnets      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
  ]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

resource "kubernetes_secret" "ecr_registry_secret" {
  metadata {
    name = "ecr-registry-secret"
  }
  
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "933920645082.dkr.ecr.eu-west-1.amazonaws.com" = {
          "auth" = "${data.aws_ecr_authorization_token.ecr.authorization_token}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

data "aws_ecr_authorization_token" "ecr" {}

# output "registry_credentials" {
#   value = kubernetes_secret.ecr_registry_secret.data[".dockerconfigjson"]
# }

resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "newsletter-subscriptions-app-deployment"
    labels = {
      test = "app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "app"
      }
    }

    template {
      metadata {
        labels = {
          test = "app"
        }
      }

      spec {
        image_pull_secrets {
          name = "ecr-registry-secret"
        }
        
        container {
          image = "933920645082.dkr.ecr.eu-west-1.amazonaws.com/newsletter-subscriptions-app-images:062db587a12b5cd2c104f695cc9690d75adac6e9"
          name  = "newsletter-subscriptions-app"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}