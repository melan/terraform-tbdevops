data "aws_iam_policy_document" "dd-policy-doc" {
  statement {
    actions = [
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "ec2:Describe*",
      "support:*",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "budgets:ViewBudget",
      "budgets:DescribeBudgets",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "dd-integration-assume-doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["arn:aws:iam::${var.dd_aws_account}:root"]
      type        = "AWS"
    }

    condition {
      test     = "StringEquals"
      values   = ["${var.dd_external_id}"]
      variable = "sts:ExternalId"
    }
  }
}

resource "aws_iam_policy" "dd-policy" {
  name   = "dd-integration-policy"
  policy = "${data.aws_iam_policy_document.dd-policy-doc.json}"
}

resource "aws_iam_role" "dd-integration-role" {
  name               = "DatadogIntegrationRole"
  assume_role_policy = "${data.aws_iam_policy_document.dd-integration-assume-doc.json}"
}

resource "aws_iam_policy_attachment" "attach-dd-integration" {
  roles      = ["${aws_iam_role.dd-integration-role.name}"]
  name       = "attach-dd-policy"
  policy_arn = "${aws_iam_policy.dd-policy.arn}"
}
