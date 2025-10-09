#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"

if [[ -z "${COCOP_SPAWNED:-}" && -n "${DISPLAY:-}" && ! -t 1 ]]; then
  export COCOP_SPAWNED=1
  qterminal -e bash -ic "env COCOP_SPAWNED=1 \"${SCRIPT_PATH}\"; echo; echo 'Press Enter to close'; read -r"
  exit 0
fi

########## Configuration ##########
PY_VER="3.11.13"
PY_TGZ="Python-${PY_VER}.tgz"
PY_DIR="Python-${PY_VER}"
PREFIX="/usr/local"
CPU_COUNT="${CPU_COUNT:-$(nproc || echo 1)}"
DOWNLOAD_URL="https://www.python.org/ftp/python/${PY_VER}/${PY_TGZ}"

########## Helpers ##########
step() {
  echo ">>> $1"
  shift; "$@"
}

########## 1. Install build deps + Tcl/Tk dev headers ##########
step "Updating apt cache" \
  sudo apt update

step "Installing build-essential, TK headers, etc." \
  sudo apt install -y build-essential \
    zlib1g-dev libncurses-dev libgdbm-dev libnss3-dev \
    libssl-dev libreadline-dev libffi-dev libsqlite3-dev \
    tk-dev tcl-dev wget

########## 2. Download & extract ##########
if [[ -f "${PY_TGZ}" ]]; then
  echo ">>> Found ${PY_TGZ}, skipping download"
else
  step "Downloading Python ${PY_VER}" \
    wget --tries=3 --continue --progress=dot:giga "${DOWNLOAD_URL}"
fi

if [[ -d "${PY_DIR}" ]]; then
  echo ">>> Source directory ${PY_DIR} exists, skipping extraction"
else
  step "Extracting ${PY_TGZ}" \
    tar -xzf "${PY_TGZ}"
fi

########## 3. Build & install ##########
step "Entering source directory ${PY_DIR}" cd "${PY_DIR}"

step "Configuring (with pip & IDLE support)" \
  ./configure --prefix="${PREFIX}" \
              --enable-optimizations \
              --with-ensurepip=install

step "Compiling (make -j${CPU_COUNT})" \
  make -j"${CPU_COUNT}"

step "Installing (sudo make altinstall)" \
  sudo make altinstall

step "Returning to parent directory" cd ..

########## 4. Verification ##########
command -v python3.11 >/dev/null && echo ">>> python3.11: OK" || echo ">>> Warning: python3.11 missing"
command -v pip3.11   >/dev/null && echo ">>> pip3.11:   OK" || echo ">>> Warning: pip3.11 missing"
command -v idle3.11  >/dev/null && echo ">>> idle3.11: OK" || echo ">>> Warning: idle3.11 missing"

echo ">>> Done. Launch IDLE via 'idle3.11' or 'python3.11 -m idlelib.idle'"
