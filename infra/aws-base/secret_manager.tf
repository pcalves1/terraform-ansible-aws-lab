
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "secrets_policy" {
  name        = "secrets_policy"
  description = "A policy to allow access to Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_secretsmanager_secret" "mysql_credentials" {
  # name        = "mysql_credentials9"
  description = "MySQL database credentials"
}

resource "aws_secretsmanager_secret_version" "mysql_credentials_version" {
  secret_id = aws_secretsmanager_secret.mysql_credentials.id
  secret_string = jsonencode({
    username = var.mysql_user
    password = var.mysql_password
  })
}
