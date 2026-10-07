resource "azurerm_virtual_network" "monitoring" {
  name                = "vnet-monitoring-prod"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  address_space       = ["10.20.0.0/16"]

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_subnet" "monitoring" {
  name                 = "snet-monitoring-prod"
  resource_group_name  = azurerm_resource_group.monitoring.name
  virtual_network_name = azurerm_virtual_network.monitoring.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_network_security_group" "monitoring" {
  name                = "nsg-monitoring-prod"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_source_cidr
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_subnet_network_security_group_association" "monitoring" {
  subnet_id                 = azurerm_subnet.monitoring.id
  network_security_group_id = azurerm_network_security_group.monitoring.id
}

resource "azurerm_public_ip" "monitoring" {
  name                = "pip-monitoring-prod"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}

resource "azurerm_network_interface" "monitoring" {
  name                = "nic-monitoring-prod"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.monitoring.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.monitoring.id
  }

  tags = {
    Environment = "Prod"
    Project     = "Monitoring-Alerting"
  }
}