#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Absolute path to this script
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"

# Spawn qterminal only when not already spawned, when a display exists, and when stdout is not a tty
if [[ -z "${COCOP_SPAWNED:-}" && -n "${DISPLAY:-}" && ! -t 1 ]]; then
  export COCOP_SPAWNED=1
  # Run the script inside an interactive shell and keep the terminal open until Enter is pressed
  qterminal -e bash -ic "env COCOP_SPAWNED=1 \"${SCRIPT_PATH}\"; echo; echo 'Press Enter to close'; read -r" 
  exit 0
fi

# Configuration
PY_VER="3.11.13"
PY_TGZ="Python-${PY_VER}.tgz"
PY_DIR="Python-${PY_VER}"
CPU_COUNT="${CPU_COUNT:-$(nproc 2>/dev/null || echo 1)}"
DOWNLOAD_URL="https://www.python.org/ftp/python/${PY_VER}/${PY_TGZ}"

# Run a command and echo the step before executing it
step() {
  local msg="$1"; shift
  echo ">>> $msg"
  "$@"
}

# Run a command but only echo the step description (no command)
step_msg() {
  echo ">>> $1"
}

# Start
step_msg "Starting Python ${PY_VER} download script"

# Download step
step_msg "Checking for existing archive ${PY_TGZ}"
if [[ -f "${PY_TGZ}" ]]; then
  echo ">>> Found ${PY_TGZ}, skipping download"
else
  echo ">>> Downloading ${DOWNLOAD_URL}"
  if command -v wget >/dev/null 2>&1; then
    step "wget --tries=3 --continue --progress=dot:giga ${DOWNLOAD_URL}" wget --tries=3 --continue --progress=dot:giga "${DOWNLOAD_URL}"
  elif command -v curl >/dev/null 2>&1; then
    step "curl -fLo ${PY_TGZ} --retry 3 --retry-connrefused --retry-delay 2 ${DOWNLOAD_URL}" curl -fLo "${PY_TGZ}" --retry 3 --retry-connrefused --retry-delay 2 "${DOWNLOAD_URL}"
  else
    echo ">>> Error: neither wget nor curl available" >&2
    exit 1
  fi
fi

# Verify archive
step_msg "Verifying the archive exists"
if [[ -f "${PY_TGZ}" ]]; then
  echo ">>> ${PY_TGZ} is present"
else
  echo ">>> Error: ${PY_TGZ} missing after download" >&2
  exit 1
fi

# Extract step
if [[ -d "${PY_DIR}" ]]; then
  echo ">>> ${PY_DIR} already exists, skipping extraction"
else
  step "tar -xzf ${PY_TGZ}" tar -xzf "${PY_TGZ}"
fi

# Build step (commented out by default)
echo ">>> Build steps are commented out by default. Uncomment to build/install."
# PREFIX="/usr/local"
# step "cd ${PY_DIR}" bash -c "cd ${PY_DIR}"
# step "./configure --prefix=${PREFIX} --enable-optimizations" bash -c "cd ${PY_DIR} && ./configure --prefix=\"${PREFIX}\" --enable-optimizations"
# step "make -j${CPU_COUNT}" bash -c "cd ${PY_DIR} && make -j\"${CPU_COUNT}\""
# step "sudo make altinstall" bash -c "cd ${PY_DIR} && sudo make altinstall"

echo ">>> Done."
