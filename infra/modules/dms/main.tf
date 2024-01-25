# Put IAM Roles here
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_policy" "dms_access" {
  name   = "dms-access"
  policy = data.aws_iam_policy_document.dms_access.json
}
resource "aws_iam_role" "dms_access" {
  name               = "dms-access-role"
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role_policy.json
}

data "aws_iam_policy_document" "dms_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Attach access policies to role
resource "aws_iam_role_policy_attachment" "dms_access" {
  role       = aws_iam_role.dms_access.name
  policy_arn = aws_iam_policy.dms_access.arn
}

# Rough draft of IAM policies
data "aws_iam_policy_document" "dms_access" {
  statement {
    sid       = "AllowDMSAccess"
    effect    = "Allow"
    actions   = ["dms:*"]
    resources = [""] # arn for the actual dms service goes here
  }

  statement {
    # Allows DMS to create the roles it needs if not created beforehand
    # Actions List: https://docs.aws.amazon.com/service-authorization/latest/reference/list_awsidentityandaccessmanagementiam.html
    sid    = "AllowCreateIAM"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:PassRole",
      "iam:CreateRole",
      "iam:AttachRolePolicy"
    ]
    resources = ["arn:aws:iam:*:${data.aws_caller_identity.current.account_id}:*"]
  }
  statement {
    # Allow DMS to configure the network it needs
    # Actions List: https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonec2.html
    sid    = "EC2Access"
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface"
    ]
    resources = ["arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:*"]
  }
  statement {
    # View replication metrics
    sid       = "AllowCloudwatchMetrics"
    effect    = "Allow"
    actions   = ["cloudwatch:Get*", "cloudwatch:List*"]
    resources = ["*"]
  }
  statement {
    # View replication logs
    sid    = "AllowCloudwatchLogs"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:ilterLogEvents",
      "logs:GetLogEvents"
    ]
    resources = ["*"] # don't have log group yet
  }
}