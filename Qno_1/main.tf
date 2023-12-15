provider "aws" {
  region = "us-east-1"  
}

resource "aws_iam_group" "test-group" {
  name = var.group_name
}



resource "aws_iam_user" "test-user" {
  name = var.user_name
  
  }

  resource "aws_iam_user_group_membership" "example1" {
  user = aws_iam_user.test-user.name
  groups = [aws_iam_group.test-group.name]
    
 }