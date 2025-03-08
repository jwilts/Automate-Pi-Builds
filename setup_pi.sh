#!/bin/bash
# Version 4
# How to make the script executable:
# chmod u+rx setup_pi.sh
# How to execute the script:
# ./setup_pi.sh
# How to activate virtual environment:
# source <directory>/.venv/bin/activate
# How to deactivate the virtual environment:
# deactivate

# Set the environment variable to suppress any interactive activities during the installation
export DEBIAN_FRONTEND=noninteractive

# Array to store failed steps
FAILED_STEPS=()

# Function to check if a command fails
check_failure() {
    if [ $? -ne 0 ]; then
        FAILED_STEPS+=("$1")
    fi
}

# ===== New Section: Prompt for Hostname and Reboot =====
read -p "Enter the hostname for this system: " NEW_HOSTNAME
echo "Setting hostname to $NEW_HOSTNAME..."
sudo hostnamectl set-hostname "$NEW_HOSTNAME"
check_failure "Set hostname to $NEW_HOSTNAME"

# Update /etc/hosts to reflect the new hostname (assumes the line starting with 127.0.1.1 exists)
sudo sed -i "s/^127\.0\.1\.1.*/127.0.1.1    $NEW_HOSTNAME/" /etc/hosts
check_failure "Update /etc/hosts with new hostname"

echo "Hostname updated. The system will now reboot to apply the changes."
sudo reboot
exit 0
# ===== End New Section =====

# (The remaining steps below will execute only after the system is rebooted and the script is run again.)

# Enable SPI
echo "Enabling SPI..."
sudo raspi-config nonint do_spi 0
check_failure "Enable SPI"

# Enable I2C
echo "Enabling I2C..."
sudo raspi-config nonint do_i2c 0
check_failure "Enable I2C"

# Enable SSH
echo "Enabling SSH..."
sudo raspi-config nonint do_ssh 0
check_failure "Enable SSH"

# Enable VNC
echo "Enabling VNC..."
sudo raspi-config nonint do_vnc 0
check_failure "Enable VNC"

# Enable Serial Port (No for shell over Serial Port, Yes for Serial Port hardware)
echo "Enabling Serial Port hardware, disabling shell over serial..."
sudo raspi-config nonint do_serial 1
check_failure "Enable Serial Port"

# Disable screen blanking
echo "Disabling screen blanking..."
sudo bash -c 'echo -e "\n# Disable screen blanking\nxserver-command=X -s 0 dpms" >> /etc/lightdm/lightdm.conf'
check_failure "Disable screen blanking"

# Directories for virtual environments
directories=("CubCar" "Mega" "Pico")

# Update package list
echo "Updating package list..."
sudo apt-get update
check_failure "Update package list"

# Upgrade all installed packages
echo "Upgrading installed packages..."
sudo apt-get upgrade -y
check_failure "Upgrade installed packages"

# Install python3-pip
echo "Installing python3-pip..."
sudo apt-get install -y python3-pip
check_failure "Install python3-pip"

# Install ntp
echo "Installing ntp..."
sudo apt-get install -y ntp
check_failure "Install ntp"

# Install python3 development tools
echo "Installing python3-dev and additional pip..."
sudo apt-get install -y python3-dev python3-pip
check_failure "Install python3-dev and pip"

# Install alternative GPIO library
echo "Installing alternative GPIO library..."
sudo apt remove -y python3-rpi.gpio
sudo apt update -y
pip install rpi-lgpio
check_failure "Install alternative GPIO library"

# Install GIT
echo "Installing GIT..."
sudo apt install git -y
check_failure "Install GIT"

# Install MFRC522 Library
echo "Installing MFRC522 Library..."
git clone https://github.com/danjperron/MFRC522-python
check_failure "Install MFRC522 Library"

# Install python3-venv for creating virtual environments
echo "Installing python3-venv..."
sudo apt-get install -y python3-venv
check_failure "Install python3-venv"

# Install Pillow system-wide
echo "Installing Pillow system-wide..."
pip install Pillow
check_failure "Install Pillow system-wide"

# Loop through directories to create virtual environments and install packages
for directory in "${directories[@]}"
do
    echo "Creating $directory directory..."
    mkdir -p "$directory"
    check_failure "Create $directory directory"
    cd "$directory"

    echo "Creating virtual environment named .venv in $directory..."
    python3 -m venv .venv
    check_failure "Create virtual environment in $directory"

    echo "Activating the virtual environment in $directory..."
    source .venv/bin/activate
    check_failure "Activate virtual environment in $directory"

    echo "Upgrading pip and setuptools in $directory..."
    pip3 install --upgrade pip setuptools
    check_failure "Upgrade pip and setuptools in $directory"

    echo "Installing Python packages in $directory..."
    pip3 install mysql-connector-python
    check_failure "Install mysql-connector-python in $directory"
    pip3 install pyserial
    check_failure "Install pyserial in $directory"
    pip3 install spidev
    check_failure "Install spidev in $directory"
    pip3 install smbus2
    check_failure "Install smbus2 in $directory"
    pip3 install rpi_ws281x
    check_failure "Install rpi_ws281x in $directory"
    pip3 install rpi-lgpio
    check_failure "Install rpi-lgpio in $directory"

    # Install Pillow in the virtual environment
    echo "Installing Pillow in $directory..."
    pip3 install Pillow
    check_failure "Install Pillow in $directory"

    echo "Deactivating virtual environment in $directory..."
    deactivate
    check_failure "Deactivate virtual environment in $directory"

    cd ..
done

# Install python3-pandas system-wide (outside virtual environments)
echo "Installing python3-pandas system-wide..."
sudo apt-get install -y python3-pandas
check_failure "Install python3-pandas system-wide"

# Display summary of failures
if [ ${#FAILED_STEPS[@]} -eq 0 ]; then
    echo "All tasks completed successfully!"
else
    echo "The following steps encountered errors:"
    for step in "${FAILED_STEPS[@]}"; do
        echo "- $step"
    done
fi
