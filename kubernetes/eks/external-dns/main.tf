provider "aws" {
  region     = "us-east-1"
}



resource "aws_iam_role" "external_dns_role" {
    name = "eks-external-dns-dev"

    assume_role_policy = jsonencode(
        {
            "Version": "2012-10-17",
            "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                   "Service": "ec2.amazonaws.com"
            },
                "Effect": "Allow",
                "Sid": ""
                }
            ]
        }
    )
}



resource "aws_iam_role_policy" "external_dns_policy" {
  name = "external-dns-role-policy-dev"
  role = aws_iam_role.external_dns_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.external_dns_role.name
}

output "external_dns_role_arn" {
    value = aws_iam_role.external_dns_role.arn
}

