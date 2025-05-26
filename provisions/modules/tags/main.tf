locals {

  tags = merge(
    {
      "Name"        = "devops-eks"
      "Environment" = "dev"
      "Owner"       = "minhvu"
      "Project"     = "devops-eks"
    },
    var.tags
  )
}