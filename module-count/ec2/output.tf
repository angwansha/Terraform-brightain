output "MyInstnaceIDs" {
  value = [aws_instance.ec2.*.id]
}