#!/bin/bash

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

VERSION=$(curl -s https://api.github.com/repos/zkSNACKs/WalletWasabi/releases/latest | grep tag_name | cut -d ':' -f 2 | cut -d '"' -f 2 | cut -d 'v' -f 2)
NAME=WasabiLinux-${VERSION}
CUR_DIR=${pwd}
DEST_DIR=${HOME}/.local/bin/${NAME}
TEMP_DIR=$(mktemp -d)
ICON=WasabiLogo48.png

if [[ ! ${TEMP_DIR} || ! -d ${TEMP_DIR} ]]; then
  echo "ERROR: Could not create temporary directory: ${TEMP_DIR}"
  exit 1
fi

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
gpg --verify ${NAME}.tar.gz.asc ${NAME}.tar.gz

echo -e "\nIf the PGP verification message says:"
echo "1) Good signature, and"
echo "2) It was signed by: Ficsór Ádám, and"
echo "3) Primary key fingerprint is: 21D7 CA45 565D BCCE BE45 115D B4B7 2266 C47E 075E"
echo -e "then the software has not been tampered with and you can continue.\n"

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
