#!/bin/bash

# Open a qterminal and run a sequence of commands interactively
qterminal -e "bash -lc '
set -e
echo \"Starting: fetch Kali archive keyring and update apt\"
sudo wget https://archive.kali.org/archive-keyring.gpg -O /usr/share/keyrings/kali-archive-keyring.gpg
sudo apt update

echo
echo \"Installing OpenJDK 11\"
sudo apt install openjdk-11-jdk -y

echo
echo \"Java versions before alternatives (checks)\"
java -version
javac -version || true

echo
echo \"Configure alternatives for java (choose the number for OpenJDK 11)\"
sudo update-alternatives --config java

echo
echo \"Configure alternatives for javac (choose the number for OpenJDK 11)\"
sudo update-alternatives --config javac

echo
echo \"Final java checks\"
java -version
javac -version

echo
read -p \"All done. Press Enter to close this terminal...\"'
"
