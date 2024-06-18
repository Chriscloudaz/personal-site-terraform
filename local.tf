locals {
  vpc_name        = format("%s-%s-%s", var.prefix, "eks", "vpc")
  cluster_name    = format("%s-%s-%s", var.prefix, "eks", "cluster")
  rds_name        = format("%s-%s-%s", var.prefix, "rds", "instance")
}