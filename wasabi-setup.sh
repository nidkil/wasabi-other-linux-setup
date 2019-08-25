#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

VERSION=$(curl -s https://api.github.com/repos/zkSNACKs/WalletWasabi/releases/latest | grep tag_name | cut -d ':' -f 2 | cut -d '"' -f 2 | cut -d 'v' -f 2)
NAME=WasabiLinux-${VERSION}
CUR_DIR=${pwd}
DEST_DIR=${HOME}/.local/bin/${NAME}
TEMP_DIR=$(mktemp -d)
ICON=WasabiLogo48.png

PGP_GOOD_SIG="Good signature"
PGP_SIGNED_BY="Ficsór Ádám"
PGP_FINGERPRINT="21D7CA45565DBCCEBE45115DB4B72266C47E075E"
# Split string into slices of 4 digits and strip leading and trailing spaces
PGP_FINGERPRINT_FORMATTED=$(echo -e $(echo ${PGP_FINGERPRINT} | awk '{gsub(/.{4}/,"& ")}1'))

cleanup() {
  rm -rf ${TEMP_DIR}
  cd ${CUR_DIR}
}

continue() {
  while true; do
      read -p "Continue [yN]? " yn
      case $yn in
          [Yy]* ) break;;
          [Nn]* ) exit;;
          "" ) exit;;
          * ) echo "Please answer Y or N.";;
      esac
  done
}

has_string() {
  STR=$1
  FIND=$2
  MSG=$3
  if [[ "${STR}" == *"${FIND}"* ]]; then
    echo -e "${MSG}: ${GREEN}PASS${NC}"
  else
    echo -e "${MSG}: ${RED}FAIL${NC}"
    PGP_VALIDATION_FAILED=true
  fi
}

# Register the cleanup function to be called on the EXIT signal to ensure cleanup always happens
# to avoid orphaned directories and files
trap cleanup EXIT

echo "Installing Wasabi Wallet: VERSION=${VERSION}, NAME=${NAME}, TEMP_DIR=${TEMP_DIR}"

if [ -d ${DEST_DIR} ]; then
  echo -e "\nThe latest version is already installed. If you continue it will be re-installed.\n"

  continue

  rm -rf ${DEST_DIR}
fi

cd ${TEMP_DIR}

echo -e "\nDownloading files (please be patient, this might take a while depending on your network speed)"
wget -q --show-progress -o debug.log https://raw.githubusercontent.com/zkSNACKs/WalletWasabi/master/PGP.txt
wget -q --show-progress -o debug.log https://github.com/zkSNACKs/WalletWasabi/releases/download/v${VERSION}/${NAME}.tar.gz
wget -q --show-progress -o debug.log https://github.com/zkSNACKs/WalletWasabi/releases/download/v${VERSION}/${NAME}.tar.gz.asc
wget -q --show-progress -o debug.log https://raw.githubusercontent.com/zkSNACKs/WalletWasabi/master/WalletWasabi.Gui/Assets/${ICON}

echo -e "\nVerifying PGP signature of file: ${NAME}.tar.gz\n"
# HACK: output of gpg will not capture with $(gpg .. ..), why?
gpg --verify ${NAME}.tar.gz.asc ${NAME}.tar.gz > ${TEMP_DIR}/pgp.validation 2>&1
PGP_INFO=$(cat ${TEMP_DIR}/pgp.validation)

echo -e "${PGP_INFO}\n"

PGP_VALIDATION_FAILED=false

has_string "${PGP_INFO}" "${PGP_GOOD_SIG}" "1) ${PGP_GOOD_SIG}"
has_string "${PGP_INFO}" "${PGP_SIGNED_BY}" "2) It was signed by ${PGP_SIGNED_BY}"
has_string "${PGP_INFO}" "${PGP_FINGERPRINT}" "3) Primary key fingerprint is ${PGP_FINGERPRINT_FORMATTED}"

if [[ "${PGP_VALIDATION_FAILED}" == "true" ]]; then
  echo -e "\n${RED}PGP sginature validation failed${NC}"
  exit
fi

echo ""
continue

echo -e "\nUnpacking archive and moving it to: ${DEST_DIR}"
mkdir -p ${DEST_DIR}
tar -pxzf ${NAME}.tar.gz -C ${DEST_DIR} --strip-components 1
mv ${ICON} ${DEST_DIR}/.

echo "Creating desktop shortcut"
echo "[Desktop Entry]
Encoding=UTF-8
Version=${VERSION}
Name[en_US]=Wasabi Wallet
GenericName=Wasabi Wallet - Desktop
Exec=${DEST_DIR}/wassabee
Terminal=false
Icon[en_US]=${DEST_DIR}/${ICON}
Type=Application
Categories=Application;Finance;Crypto;Wallet;
Comment[en_US]=Wasabi Wallet - Desktop
" | envsubst > ~/.local/share/applications/wasabi-wallet.desktop
chmod ugo+x ~/.local/share/applications/wasabi-wallet.desktop

echo "Cleaning up"
cleanup

echo -e "\nYou can now run Wasabi Wallet from the Application menu or execute it"
echo "from the command-line '${DEST_DIR}/wassabee'"
echo -e "\nHappy shuffling!"
