param location string = resourceGroup().location
param adminUsername string = 'cloudadmin'
@secure()
param adminPassword string = 'ZAQ!2wsxCDE#'
param sourceIp string = '153.240.191.5'
param vmHostName string = 'vm-LinuxVM'
// var customData = '''
// #cloud-config
// packages:
//   - httpd
// runcmd:
//   - systemctl start httpd
//   - systemctl enable httpd
//   - touch /var/www/html/index.html
//   - echo $HOSTNAME > /var/www/html/index.html
//   - systemctl stop firewalld
//   - systemctl disable firewalld
// '''
var customData = loadFileAsBase64('./customdata.yaml')

resource linuxVM 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myLinuxVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    osProfile: {
      computerName: vmHostName
      
      adminUsername: adminUsername
      adminPassword: adminPassword
      // customData: base64(customData)
      customData: customData
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        ssh: {}
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'RedHat'
        offer: 'RHEL'
        sku: '87-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: 'myNic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'myIpConfig'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: myPublicIp.id
          }
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: 'myVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'mySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'myNsg'
  location: location
  properties: {
    securityRules: [
      {
        id: 'Allow-SSH'
        name: 'Allow-SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: sourceIp
          destinationPortRange: '22'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        id: 'Allow-HTTP'
        name: 'Allow-HTTP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: sourceIp
          destinationPortRange: '80'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource myPublicIp 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'myPublicIp'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}
