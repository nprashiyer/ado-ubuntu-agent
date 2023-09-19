resource "azurerm_public_ip" "agent" {
  name                = "${var.agent_name}-pip"
  resource_group_name = data.azurerm_resource_group.example.agent.name
  location            = data.azurerm_resource_group.agent.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "agent" {
  name                = "${var.agent_name}-nic"
  location            = data.azurerm_resource_group.agent.location
  resource_group_name = data.azurerm_resource_group.example.agent.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.agent.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.agent.id
  }
}

resource "azurerm_linux_virtual_machine" "agent" {
  name                = var.agent_name
  resource_group_name = data.azurerm_resource_group.example.agent.name
  location            = data.azurerm_resource_group.agent.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = var.admin_password 
  
  network_interface_ids = [
    azurerm_network_interface.agent.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}