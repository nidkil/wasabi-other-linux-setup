#!/bin/bash

cleanup() {
  rm PGP.txt Wasabi* debug.log
}

VERSION=$(curl -s https://api.github.com/repos/zkSNACKs/WalletWasabi/releases/latest | grep tag_name | cut -d ':' -f 2 | cut -d '"' -f 2 | cut -d 'v' -f 2)
NAME=WasabiLinux-${VERSION}
ICON=WasabiLogo48.png

cleanup

echo "Installing Wasabi Wallet: VERSION=${VERSION}, NAME=${NAME}"

cd ~/Downloads

echo -e "\nDownloading files (please be patient, this might take a while depending on your network speed)"
wget -q -o debug.log https://raw.githubusercontent.com/zkSNACKs/WalletWasabi/master/PGP.txt
wget -q -o debug.log https://github.com/zkSNACKs/WalletWasabi/releases/download/v${VERSION}/${NAME}.tar.gz
wget -q -o debug.log https://github.com/zkSNACKs/WalletWasabi/releases/download/v${VERSION}/${NAME}.tar.gz.asc
wget -q -o debug.log https://raw.githubusercontent.com/zkSNACKs/WalletWasabi/master/WalletWasabi.Gui/Assets/${ICON}

echo -e "Verifying PGP signature of file: ${NAME}.tar.gz\n"
gpg --verify ${NAME}.tar.gz.asc ${NAME}.tar.gz

echo -e "\nIf the PGP verification message says:"
echo "1) Good signature, and"
echo "2) It was signed by: Ficsór Ádám, and"
echo "3) Primary key fingerprint is: 21D7 CA45 565D BCCE BE45 115D B4B7 2266 C47E 075E"
echo -e "then the software has not been tampered with and you can continue.\n"

while true; do
    read -p "Continue [yN]? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        "" ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

echo -e "\nUnpacking archive and moving it to: ~/WasabiLinux-${VERSION}"
tar -pxzf ${NAME}.tar.gz -C ~
mv ${ICON} ~/${NAME}/.

echo "Creating desktop shortcut"
echo "[Desktop Entry]
Encoding=UTF-8
Version=${VERSION}
Name[en_US]=Wasabi Wallet
GenericName=Wasabi Wallet - Desktop
Exec=${HOME}/WasabiLinux-${VERSION}/wassabee
Terminal=false
Icon[en_US]=${HOME}/WasabiLinux-${VERSION}/${ICON}
Type=Application
Categories=Application;Finance;Crypto;Wallet;
Comment[en_US]=Wasabi Wallet - Desktop
" | envsubst > ~/.local/share/applications/wasabi-wallet.desktop
chmod ugo+x ~/.local/share/applications/wasabi-wallet.desktop

echo "Cleaning up"
cleanup

echo -e "\nYou can now run Wasabi Wallet from the Application menu or"
echo "execute it from the command-line '~/WasabiLinux-${VERSION}/wassabee'"
echo -e "\nHappy shuffling!"
