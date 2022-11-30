data "aws_vpc" "vpc" {
  filter {
    name = "vpc-id"
    values = [var.vpc_id]
  }
}

### Subnets
# private subnets
data "aws_subnets" "private" {
    
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc.id]
    }

    filter {
        name   = "tag:Name"
        values = ["*private*"]
    }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}


# public subnets
data "aws_subnets" "public" {
    
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.vpc.id]
    }

    filter {
        name   = "tag:Name"
        values = ["*public*"]
    }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

