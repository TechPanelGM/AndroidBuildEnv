#!/bin/bash

# Function to prompt user for input
prompt_user() {
    read -p "$1: " input
    echo $input
}

# Prompt user for email, username, and ccache size
email=$(prompt_user "Enter your github email")
username=$(prompt_user "Enter your github username")
ccache_size=$(prompt_user "Enter ccache preferred size (e.g., 50G)")

# Install required packages
sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32readline-dev lib32z1-dev libelf-dev liblz4-tool libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev -y

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)

if [ "$(printf '%s\n' "23.10" "$UBUNTU_VERSION" | sort -V | head -n1)" = "23.10" ]; then
    # If Ubuntu version is 23.10
    wget http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.4-2_amd64.deb && sudo dpkg -i libtinfo5_6.4-2_amd64.deb && rm -f libtinfo5_6.4-2_amd64.deb
    wget http://archive.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.4-2_amd64.deb && sudo dpkg -i libncurses5_6.4-2_amd64.deb && rm -f libncurses5_6.4-2_amd64.deb
elif [ "$(printf '%s\n' "20.04" "$UBUNTU_VERSION" | sort -V | head -n1)" = "20.04" ]; then
    # If Ubuntu version is older than 23.10 but not older than 20.04
    sudo apt install lib32ncurses5-dev libncurses5 libncurses5-dev -y
elif [ "$(printf '%s\n' "16.04" "$UBUNTU_VERSION" | sort -V | head -n1)" = "16.04" ]; then
    # If Ubuntu version is older than 20.04 but not older than 16.04
    sudo apt install libwxgtk3.0-dev -y
else
    # If Ubuntu version is older than 16.04
    sudo apt install libwxgtk2.8-dev -y
fi

# Install OpenJDK 11
sudo apt install openjdk-11-jdk -y

# Install python-is-python3
sudo apt install python-is-python3 -y

# Create bin directory in home
mkdir -p ~/bin

# Download repo tool
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

# Add bin directory to PATH in ~/.profile
echo 'if [ -d "$HOME/bin" ] ; then' >> ~/.profile
echo '    PATH="$HOME/bin:$PATH"' >> ~/.profile
echo 'fi' >> ~/.profile

# Source ~/.profile to update PATH
source ~/.profile

# Configure Git
git config --global user.email "$email"
git config --global user.name "$username"

# Install Git LFS
git lfs install

# Configure ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache

# Set ccache size and enable compression
ccache -M $ccache_size
ccache -o compression=true

echo "Environment setup complete!"
