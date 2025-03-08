# Automate-Pi-Builds
setup_pi.sh
A shell script to automate the setup of a Raspberry Pi environment.
Version: 4

Description
This script configures a Raspberry Pi by:

Prompting the user to set a new hostname, then rebooting to apply the change.
Enabling various interfaces (SPI, I2C, SSH, VNC, Serial).
Disabling screen blanking.
Installing and upgrading packages including Python, pip, and other dependencies.
Creating multiple virtual environments (for CubCar, Mega, and Pico) and installing specific Python packages within each environment.
Table of Contents
Prerequisites
Installation
Usage
Script Flow
Troubleshooting
License
Prerequisites
A Raspberry Pi with an operating system that supports raspi-config (e.g., Raspberry Pi OS).
A network connection to install packages.
Sufficient permissions to run sudo commands.
Installation
Clone or Download:

Either clone this repository or download the script (setup_pi2.sh) onto your Raspberry Pi.
Make Script Executable (Optional but Recommended):

bash
Copy
Edit
chmod u+rx setup_pi2.sh
This step ensures you can run the script directly without typing bash.

Usage
Run the Script:

bash
Copy
Edit
./setup_pi.sh
If you did not make it executable, then run:
bash
Copy
Edit
bash setup_pi.sh
Enter Your Desired Hostname:

When prompted, type the hostname you want to set for the Raspberry Pi.
Automatic Reboot:

The system will reboot immediately after changing the hostname.
Re-run the Script (After Reboot):

Once the Pi reboots, log in again and run the script one more time:
bash
Copy
Edit
./setup_pi.sh
This time, it will proceed with installing packages, enabling services, creating virtual environments, etc.
Activating/Deactivating Virtual Environments
After the script completes, you will have three directories: CubCar, Mega, and Pico. Each contains its own Python virtual environment named .venv.

Activate a virtual environment:

bash
Copy
Edit
source <directory>/.venv/bin/activate
(Replace <directory> with the actual name, e.g., CubCar.)

Deactivate a virtual environment:

bash
Copy
Edit
deactivate
Script Flow
Below is a summarized flow of what happens when the script runs:

Hostname Update & Reboot

Prompts for the new hostname.
Updates /etc/hosts and sets the system hostname.
Reboots to apply changes.
Post-Reboot Configuration

Enables SPI, I2C, SSH, VNC, and configures the serial port.
Disables screen blanking by appending settings to /etc/lightdm/lightdm.conf.
System Updates & Package Installations

Runs sudo apt-get update and sudo apt-get upgrade -y.
Installs core tools like python3-pip, python3-dev, python3-venv, and other dependencies (e.g., rpi-lgpio, mysql-connector-python, pyserial, etc.).
Creation of Virtual Environments

Creates directories: CubCar, Mega, and Pico.
For each directory:
Creates a virtual environment (.venv).
Activates the environment.
Upgrades pip and setuptools.
Installs required Python packages.
Deactivates the environment.
Summary

Outputs any errors encountered in the process.
If all tasks complete without issue, prints a success message.
Troubleshooting
Permissions Errors: If you see “Permission denied,” ensure the script is executable (chmod u+rx setup_pi2.sh) and that you’re running it with appropriate privileges.
Network/Repository Issues: The script relies on external repositories. Confirm you have an active internet connection and that sudo apt-get update works correctly.
Interrupted Installations: If the script fails mid-installation, re-run the script. It will attempt to redo any failed steps.
Virtual Environment Errors: Make sure you have python3-venv installed. If you cannot activate the environment, check that the .venv/bin/activate file exists.
License
This project is provided as-is with no warranty. Feel free to modify the script for your own needs.

Enjoy your newly configured Raspberry Pi! If you have questions or issues, please open an issue or submit a pull request.
