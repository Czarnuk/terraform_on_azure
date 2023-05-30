resource "null_resource" "addfiles" {
  provisioner "file" {
    source = "Default.html"
    destination = "/var/www/html/Default.html"

    connection {
      type = "ssh"
      user = "linuxuser"
      private_key = file("${local_file.linuxpemkey.filename}")
      host = "${azurerm_public_ip.appip.ip_address}"
    }
  }
  depends_on = [ 
    azurerm_linux_virtual_machine.linuxvm, 
    local_file.linuxpemkey 
  ]
}