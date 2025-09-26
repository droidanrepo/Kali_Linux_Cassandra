#!/bin/bash

qterminal -e "bash -lc '
set -euo pipefail

PY_BIN=/usr/local/bin/python3.11
VENV_DIR=\$HOME/cassandra-env
PKGS=\"six cassandra-driver matplotlib\"

echo \"Using Python binary: \$PY_BIN\"
if [ ! -x \"\$PY_BIN\" ]; then
  echo \"Error: \$PY_BIN not found or not executable.\"
  echo \"Adjust PY_BIN to the correct path and re-run the script.\"
  read -p \"Press Enter to close...\"
  exit 1
fi

echo
echo \"Creating venv at: \$VENV_DIR\"
\$PY_BIN -m venv \"\$VENV_DIR\"

echo
echo \"Activating venv\"
# activate remains inside this qterminal session
. \"\$VENV_DIR/bin/activate\"

echo
echo \"Upgrading pip, setuptools, wheel\"
python -m pip install --upgrade pip setuptools wheel

echo
echo \"Current pip and Python versions\"
python --version
python -m pip --version

echo
echo \"Installing packages: \$PKGS\"
python -m pip install \$PKGS

echo
echo \"Installed packages:\"
python -m pip list

echo
read -p \"All done. Press Enter to close this terminal...\"
'"
