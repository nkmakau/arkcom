resource "aws_cloud9_environment_ec2" "cloud9" {

  description                 = "Cloud9 for nkmakau"
  instance_type               = "t2.micro"
  name                        = "${var.region}-${var.project}-nkmakau-cloud9"
  automatic_stop_time_minutes = "30"
  connection_type             = "CONNECT_SSH"
  image_id                    = "amazonlinux-2-x86_64"
  subnet_id                   = data.aws_subnet.public_subnet.id
  /* owner_arn                   = "${var.devops_arn}/${each.value}@safaricom.co.ke" */

  
  tags = merge(
    var.tags,
    /* {
      Name = "${var.region}-${var.project}-${each.value}-cloud9"
    }, */
  )
}
