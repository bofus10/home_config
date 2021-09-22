#!/bin/bash

#Avoiding CRTl C
function ctrl_c()
{
    let ctrlc_count++
    echo
    if [[ $ctrlc_count == 1 ]]; then
        echo "Please avoid Interrupting the process."
    elif [[ $ctrlc_count == 2 ]]; then
        echo "Once more and I quit."
    else
        echo "That's it.  I quit."
        exit
    fi
}

trap ctrl_c INT

#Update Repo
echo "Updating Repositories"
sudo apt-get update 

#Install Curl
echo "Installing basic packages"
sudo apt-get install curl pyhton3 python3-pip apt-transport-https ca-certificates

#Change Shell to ZSH
echo "Moving to ZSH"
if [[ -f /usr/bin/zsh ]];then
    chsh -s $(which zsh)
else
    sudo apt-get install zsh
    chsh -s $(which zsh)
fi

##Install Oh-my-ZSH
echo "Installing Oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

##Install Powerline
echo "Instaling Powerline"
/usr/bin/pip3 install powerline-status

##Install Fonts
echo "Setting up fonts"
mkdir -p ~/.fonts && tar -zxf fonts.tar.gz -C ~/.fonts
fc-cache -f -v

##Move zsh config
###Move .zshrc
echo "Setting up ZSH"
cp zshrc ~/.zshrc

###Move .p10k
echo "Setting up Powerlevel10k"
cp p10k.zsh ~/.p10k.zsh

###Move .oh-my-zsh plugins
echo "Loading Plugins"
tar -zxf ohmyzsh_plugins.tar.gz -C ~/.oh-my-zsh/custom/plugins/

###Refresh
rm -f ~/.zcompdump; compinit

#Installing Packages
#Install tilix
echo "Installing Tilix Terminal"
sudo apt-get -y install tilix

##Tilix scheme
echo "Loading Tilix Scheme.. This needs to be set as default after!!!!"
if [[ -d ~/.config/tilix ]]; then
    tar -zxf tilix_scheme.tar.gz -C ~/.config/tilix/
else
    mkdir -p ~/.config/tilix/ && tar -zxf tilix_scheme.tar.gz -C ~/.config/tilix/
fi

#Install Kubectl and Docker
echo "Installing Docker and Kubectl"
sudo apt-get -y install docker
##Google GPG
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
##Repo
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl helm minikube

#Install VSCode with snap
echo "Installing VS Code"
sudo snap install --classic code
##Copy Code Extensions
echo "Loading VS Code Plugins"
if [[ -d ~/.vscode ]]; then
    tar -zxf extensions.tar.gz -C ~/.vscode/
else
    mkdir -p ~/.vscode && tar -zxf extensions.tar.gz -C ~/.vscode/
fi

read -p "Reboting to apply changes... continue? [y/*]" accept
if [[ $accept == "y" ]] || [[ $accept == "Y" ]]; then
    sudo reboot
else
    echo "Aborting... a reboot is still needed."
fi
