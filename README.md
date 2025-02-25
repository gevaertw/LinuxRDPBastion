# Overview
<img src="./Arch.svg">
 
# Prerequisites on laptop 
- Assuming you work from a Linux or Mac pc (bash behaves funky on Windows / WSL)
- bash
- az cli
- jq

# Install base
- You need to do this only once.  Contains bastion, wich could be a pricy component.  You can delete it and redeploy to save some EUR
- Execute the script:
```bash
deployNetwork.sh
```


# Install a VM
- You can insatll as many VM's as you like by selecting a new name.  
- Execute the script:
```bash
deployVM.sh
```

There are 3 parmeters to set in the script
```bash
VMNAME="UGR-WKS00"                      # Choose a VM Name 
VMTYPE="Standard_D4s_v5"                # Choose a type
ENABLE_AUTOSHUTDOWN="true"              # Set true if you want the VM to automaticaly shut down (shutdown time is the parameters.json)
```
- Other, more advanced parameters (including username and password) are in the parameters.json  file
- Add auto installation scripts to the simulationpc-cloud-init.yaml file.
- Once the VM is installed the cloud-init file does not get reapplied.

# Reference
- base concept of connecting to a VM
    - https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-linux-rdp

- Install xrdp
    - https://learn.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop?tabs=azure-cli
