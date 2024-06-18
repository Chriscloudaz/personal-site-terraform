provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "parbsol-tf-state-bucket"
    key            = "prod/infrastructure/parbsol.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "parbsol-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.39.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

