#!/bin/bash

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
git config --global user.email "your_email@example.com"
git config --global user.name "Your Name"

# Install Git LFS
git lfs install

# Configure ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache

# Set ccache size and enable compression
ccache -M 50G
ccache -o compression=true

echo "Environment setup complete!"
