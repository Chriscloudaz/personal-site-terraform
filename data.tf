data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "parbsol-tf-state-bucket"
    key    = "prod/infrastructure/parbsol.tfstate"
    region = "eu-north-1"
  }

  depends_on = [
    module.eks
  ]
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

data "aws_ssm_parameter" "db_password" {
  name            = aws_ssm_parameter.db_password.name
  with_decryption = true
}

data "aws_ssm_parameter" "db_username" {
  name = aws_ssm_parameter.db_username.name
}

data "aws_ssm_parameter" "db_name" {
  name = aws_ssm_parameter.db_name.name
}
