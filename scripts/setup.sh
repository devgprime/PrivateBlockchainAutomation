#!/bin/bash

#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce && echo -e "${GREEN}Docker installed.${RESET}" || echo -e "${RED}Docker installation failed.${RESET}"
else
    echo -e "${GREEN}Docker is already installed.${RESET}"
fi

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER && echo -e "${GREEN}Current user added to docker group. Log out and log back in for these changes to take effect.${RESET}" || echo -e "${RED}Failed to add user to docker group.${RESET}"

echo "Configuring Docker to start on boot..."
sudo systemctl enable docker && echo -e "${GREEN}Docker will now start on boot.${RESET}" || echo -e "${RED}Failed to configure Docker to start on boot.${RESET}"

echo "Installing Node.js and npm..."
if ! command -v node &> /dev/null; then
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs && echo -e "${GREEN}Node.js and npm installed.${RESET}" || echo -e "${RED}Node.js and npm installation failed.${RESET}"
else
    echo -e "${GREEN}Node.js and npm are already installed.${RESET}"
fi

echo "Installing Python3..."
if ! command -v python3 &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y python3 && echo -e "${GREEN}Python3 installed.${RESET}" || echo -e "${RED}Python3 installation failed.${RESET}"
else
    echo -e "${GREEN}Python3 is already installed.${RESET}"
fi

echo "Installing Azure CLI..."
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && echo -e "${GREEN}Azure CLI installed.${RESET}" || echo -e "${RED}Azure CLI installation failed.${RESET}"
else
    echo -e "${GREEN}Azure CLI is already installed.${RESET}"
fi

echo "Installing Terraform..."
if ! command -v terraform &> /dev/null; then
    curl -LO "https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip"
    sudo apt-get install -y unzip
    unzip "terraform_1.5.0_linux_amd64.zip"
    sudo mv terraform /usr/local/bin/ && echo -e "${GREEN}Terraform installed.${RESET}" || echo -e "${RED}Terraform installation failed.${RESET}"
else
    echo -e "${GREEN}Terraform is already installed.${RESET}"
fi

./deploy.sh "low"
