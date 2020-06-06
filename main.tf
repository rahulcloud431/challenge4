Provider "aws" {
}
resource "aws_instance" "gameoflifeprimary" {
ami                         = "ami-085925f297f89fce1"
instance_type               = "t2.micro"
key_name                    = "keyname"
vpc_security_group_ids      = ["sg-group123"]
associate_public_ip_address = true

provisioner "file" {
    source      = "./gameoflife.war"
    destination = "./gameoflife.war"
    
    connection {
        type                = "ssh"
        user                = "ubuntu"
        private_key         = file("./keyname.pem")
        host                = aws_instance.gameoflifeprimary.public_ip
    }
}
provisioner "remote-exec" {
    inline                  = [
        "sudo apt-get update",
        "sleep 5",
        "sudo apt-get install openjdk-8-jdk -y",
        "sleep 5",
        "sudo apt-get install tomcat8 -y",
        "sleep 5",
        "sudo cp gameoflife.war /var/lib/tomcat8/webapps/gameoflife.war",
        "sleep 05",
        "sudo service tomcat8 restart"
    ]
    connection {
        type                = "ssh"
        user                = "ubuntu"
        private_key         = file("./keyname.pem")
        host                = aws_instance.gameoflifeprimary.public_ip
    }
    
}
}
output "publicip" {
value = aws_instance.gameoflifeprimary.public_ip
}
