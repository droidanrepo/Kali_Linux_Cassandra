#!/bin/bash

# Open a qterminal and run a sequence of commands interactively
qterminal -e "bash -lc '
set -e

PY_VER=3.11.13
PY_TGZ=Python-${PY_VER}.tgz
PY_DIR=Python-${PY_VER}
CPU_COUNT=\$(nproc)

echo \"Starting: download Python ${PY_VER}\"
wget -c https://www.python.org/ftp/python/${PY_VER}/${PY_TGZ}

echo
echo \"Extracting source\"
tar -xvzf ${PY_TGZ}
cd ${PY_DIR}

echo
echo \"Updating apt and installing build dependencies\"
sudo apt update
sudo apt install -y build-essential zlib1g-dev libbz2-dev libncurses-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev liblzma-dev tk-dev wget

echo
echo \"Configuring build (no sudo)\"
./configure --enable-optimizations --with-ensurepip=install

echo
echo \"Building Python using all CPUs (no sudo)\"
make -j\${CPU_COUNT}

echo
echo \"Installing (system-wide) using altinstall to avoid replacing system python\"
sudo make altinstall

echo
echo \"Upgrading pip, setuptools, wheel for the new interpreter\"
# adjust path if your make altinstall installed python elsewhere; /usr/local/bin is default
sudo /usr/local/bin/python3.11 -m pip install --upgrade pip setuptools wheel

echo
echo \"Verification:\"
sudo /usr/local/bin/python3.11 --version
sudo /usr/local/bin/python3.11 -m pip --version

echo
read -p \"All done. Press Enter to close this terminal...\"
'"
