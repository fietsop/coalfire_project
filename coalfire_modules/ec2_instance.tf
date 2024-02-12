# Create EC2 Instances
resource "aws_instance" "bastion_instance" {
  ami           = "ami-094aa6728b151e05a"
  instance_type = "t3a.medium"
  subnet_id     = aws_subnet.public_subnet_2.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.bastion_sg.id]

  user_data = <<-EOF
    <powershell>
    # Replace 'newusername' and 'newuserpassword' with desired values
    $Username = "alain"
    $Password = ConvertTo-SecureString -String "Alinosec87@" -AsPlainText -Force
    New-LocalUser -Name $Username -Password $Password -FullName "New User" -Description "Created by Terraform" -UserMayNotChangePassword -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member $Username
    </powershell>
  EOF

  tags = {
    "Name" = "bastion1"
  }
}

# Define other EC2 instances here
