# Automating the setup of Private Blockchain
![image](https://github.com/devgprime/NodeAutomationBlockchain/assets/131144462/08abad9b-eca9-4fcf-b764-b2f77149f61b)

Request Provisioning: The user submits a provisioning request through a UI or Azure Pipeline. This request includes the desired node configurations and quantity.

Initially a user just needs to run the script setup.sh through the command ./setup.sh which will internally call a serires of processes defined below:-

Infrastructure Provisioning - Terraform Setup using the main.tf: The provisioning request is processed by Terraform, which uses Azure APIs to set up the necessary virtual machines (VMs). Based on user input, VMs are configured with the appropriate specifications. Additional networking resources such as Virtual Networks (VNets), subnets, Network Security Groups (NSGs), and network interfaces are provisioned as required. 

terraform apply -var="specification=low"
terraform apply -var="specification=medium"
terraform apply -var="specification=high"

Configuration Management - Ansible Execution: Post VM provisioning, By executing a set of Ansible playbooks and roles, the VMs are equipped with necessary internal services like Docker or Kubernetes through playbook.yml.

Image Building: After the configuration management step, the Docker or Kubernetes image of the Geth client is built. This involves creating a Dockerfile or Kubernetes manifest file that defines the necessary specifications, dependencies, and configurations. The image building process typically occurs locally or in a dedicated build environment.

Docker/Kubernetes Deployment: Once the image is built, it is pushed to a container registry or image repository. During the deployment phase, the pre-built image is pulled from the repository and deployed across each VM using Docker or Kubernetes. The image includes the required details like network ID, genesis block, boot nodes, and other network parameters.

Geth Client Initialization: With the image deployed, a startup script or service manager (like systemd) is used to start the Geth client on each VM. This triggers the synchronization process with the private Ethereum network.

Activating Validator Functionality: With the Geth client up and running, the validation process can be started. This is done by triggering a staking transaction from the Ethereum accounts associated with each node, activating their validator capabilities.

Resource Supervision: Resource supervision is enabled using Azure Monitor or Prometheus to monitor the containers or pods running the Geth client on the VMs. Essential metrics like block propagation time, network latency, and resource usage are tracked. Alerts are set up to notify in case of any significant deviations or anomalies.

Private Key Storage and Management - Azure Key Vault: For secure handling of the private keys associated with Ethereum accounts of the validator nodes, Azure Key Vault is utilized. This provides a secure and reliable way to store and retrieve these critical keys.

---------------------------------------------------------------------------------------------


