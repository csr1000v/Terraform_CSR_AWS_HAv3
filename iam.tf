resource "aws_iam_instance_profile" "csr1000v" {
  count = var.csr1000v_instance_profile != "" ? 1 : 0

  name = "csr1000v"
  role = aws_iam_role.csr_role[0].name
}

resource "aws_iam_policy" "csrpolicy" {
  count       = var.csr1000v_instance_profile != "" ? 1 : 0
  name        = "csr_policy"
  path        = "/"
  description = "My test policy"

  policy = <<EOF
{
"Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "cloudwatch:",
                "s3:",
                "ec2:AssociateRouteTable",
                "ec2:CreateRoute",
                "ec2:CreateRouteTable",
                "ec2:DeleteRoute",
                "ec2:DeleteRouteTable",
                "ec2:DescribeRouteTables",
                "ec2:DescribeVpcs",
                "ec2:ReplaceRoute",
                "ec2:DescribeRegions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DisassociateRouteTable",
                "ec2:ReplaceRouteTableAssociation",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "csr-attach" {
  count      = var.csr1000v_instance_profile != "" ? 1 : 0
  role       = aws_iam_role.csr_role[0].name
  policy_arn = aws_iam_policy.csrpolicy[0].arn
}


resource "aws_iam_role" "csr_role" {
  count                = var.csr1000v_instance_profile != "" ? 1 : 0
  name                 = "csr1000v"
  path                 = "/"
  permissions_boundary = aws_iam_policy.csrpolicy[0].arn

  assume_role_policy = <<EOF
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
EOF
}
