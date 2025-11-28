data "aws_eks_cluster" "cluster" {
  name = "lesson-7-eks"
}

data "aws_iam_openid_connect_provider" "oidc_provider" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "jenkins_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.oidc_provider.arn]
      type        = "Federated"
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:jenkins:jenkins-service-account"]
    }
  }
}

resource "aws_iam_role" "jenkins_irsa_role" {
  name               = "jenkins-${data.aws_eks_cluster.cluster.name}-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json
  tags = {
    Name = "jenkins-irsa-role"
  }
}

resource "aws_iam_policy" "jenkins_ecr_access" {
  name        = "jenkins-${data.aws_eks_cluster.cluster.name}-ecr-access-policy"
  description = "Policy for Jenkins to push and pull from ECR"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::jenkins-artifacts-${var.aws_region}",
          "arn:aws:s3:::jenkins-artifacts-${var.aws_region}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_attach" {
  role       = aws_iam_role.jenkins_irsa_role.name
  policy_arn = aws_iam_policy.jenkins_ecr_access.arn
}