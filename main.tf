provider "azurerm" {
    version = "=1.44.0"
}

# Create resource groug
resource "azurerm_resource_group" "rg" {
    name          = "${var.prefix}-rg"
    location      = var.location
}

# Create vnet
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.prefix}-vnet"
    address_space       = ["10.10.0.0/16"]
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location

    tags = {
        name = var.tag-name
    }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                    = "${var.prefix}-subnet"
    resource_group_name     = azurerm_resource_group.rg.name
    virtual_network_name    = azurerm_virtual_network.vnet.name
    address_prefix          = "10.10.0.0/24"
}

# Set and assign public IP
resource "azurerm_public_ip" "pip" {
    name                    = "${var.prefix}-pip"
    resource_group_name     = azurerm_resource_group.rg.name
    location                = azurerm_resource_group.rg.location
    allocation_method       = "Dynamic"
    idle_timeout_in_minutes = 30
}

# Create network interface and do ipconfig
resource "azurerm_network_interface" "nic" {
    name                = "${var.prefix}-nic"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location

    ip_configuration {
        name                            = "${var.prefix}-config"
        subnet_id                       = azurerm_subnet.subnet.id
        private_ip_address_allocation   = "Dynamic"
        public_ip_address_id            = azurerm_public_ip.pip.id
    }
}

# Create virtual machine and set all dependecies
resource "azurerm_virtual_machine" "windows-vm" {
    name                                = "${var.prefix}-vm"
    resource_group_name                 = azurerm_resource_group.rg.name
    location                            = azurerm_resource_group.rg.location
    network_interface_ids               = [azurerm_network_interface.nic.id]
    vm_size                             = var.vm-type

    delete_os_disk_on_termination       = true

    delete_data_disks_on_termination    = true

    storage_image_reference {
        publisher   = "MicrosoftWindowsDesktop"
        offer       = "Windows-10"
        sku         = "19h2-pro"
        version     = "latest"
    }

    storage_os_disk {
    name              = "${var.prefix}-osDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    }

    os_profile {
    computer_name  = "${var.prefix}-VM"
    admin_username = var.admin_username
    admin_password = var.admin_password
    }

    os_profile_windows_config {
    provision_vm_agent = true
    }

}
