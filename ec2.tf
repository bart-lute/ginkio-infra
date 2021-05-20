resource "aws_key_pair" "deployer" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFFJwgpYvanwSlsnR6aRSWYfCnqciE8xB4VOL4xrIiLsG1nqTbPbUSo0yvQ8MyV7VT/2HKxwyV6YPt5tFRD3PEqqs9TIuPsiAtDozNvMNvomo6Zzric8fbguiylQ1iMLKliAdBIc2sUaxUWC1Abwu+Fb2SrBGntmE6xC8SQgPBugkgTPBdWZaRWuJtDhUX/Y08jelK0bCItJ1+ufuGqa0VHXS6r5VLkGMCEt81WpBqQ7Cl1Ylepshv1/bfhqbHZYYWiybXktAnR1/yNpE3CsRcJuBSOaF83HXiV9VRFBtmLVAMp7Ib61XPMn8zpn8VJh9HkiF81aS8mQeAnFiSQqbL"
  key_name = "deployer-key"

  tags = {
    Name = "deployer-key"
  }
}

resource "aws_instance" "cpanel" {
  ami = "${local.cloud_linux_ami}"
  instance_type = "t3.small"
  key_name = aws_key_pair.deployer.key_name
  subnet_id = aws_subnet.main_a.id
  ipv6_address_count = 1
//  disable_api_termination = true
  root_block_device {
    volume_size = "30"
  }

  vpc_security_group_ids = [
    aws_security_group.cpanel.id
  ]

  tags = {
    Name = "cPanel"
    BackupPlan = "MissionCritical"
  }
}

resource "aws_eip" "cpanel_public_1" {
  instance = aws_instance.cpanel.id
  vpc = true
}
