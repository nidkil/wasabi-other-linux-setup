# Wasabi Other Linux Setup

> This is a simple bash script to automate the installation and setup of the `Other Linux` version of the [Wasabi Wallet](https://www.wasabiwallet.io/).

It does the following:
- Downloads the latest version of the Other Linux version
- Displays the PGP verification signature of the downloaded archive
- Verifies the PGP verification signature: if invalid it exits, otherwise it asks if it may continue
- Unpacks the archive and installs it in `/.local/bin` under the current users home directory
- Creates a desktop shortcut including icon :-)
- Cleans up

## Security warning

> Only run scripts that you trust. While scripts from the Internet can be useful, these scripts can potentially harm your computer. Never run them as is, but verify that they do what they claim to do.

Some general security and safety tips in regard to scripts and downloads:

- Never execute scripts from others as is.
- Always check what they do and ensure they do what's advertised.
- Be VERY careful executing scripts as root, as this gives scripts unrestricted access to your system!
- Always verify the checksum and/or PGP information of downloaded files, to ensure they have not been modified.

## Disclaimer

Run this script at your own risk. Don't trust, but verify!

## Usage

Download the script and inspect it to verify it does what it claims to do before executing it:

```
curl -sS https://raw.githubusercontent.com/nidkil/wasabi-other-linux-setup/master/wasabi-setup.sh > wasabi-setup.sh
```

Execute the script:

```
./wasabi-setup.sh
```

You can remove the script after the installation has completed:

```
rm wasabi-setup.sh
```

## Run Wasabi Wallet

You can now run Wasabi Wallet from the Application menu (Other > Wasabi Wallet) or execute it from the command-line:

```
~/.local/bin/WasabiLinux-*/wassabee
```

## Useful links

- [Wasabi Wallet](https://www.wasabiwallet.io/)
- [Wasabi Wallet Github](https://github.com/zkSNACKs/WalletWasabi/)
- [Wasabi PGP information](https://docs.wasabiwallet.io/using-wasabi/InstallPackage.html#other-linux) - see step 3

## Support & brag about us

If you like this project, please support us by starring ⭐ [this](https://github.com/nidkil/wasabi-other-linux-setup) repository. Thx!

Please let the world know about us! Brag about us using Twitter, email, blog, Discord, Slack, forums, etc. etc. Thx!

## Author

**nidkil** © [nidkil](https://github.com/nidkil), released under the [MIT](LICENSE.md) license.
Authored and maintained by nidkil with help from [contributors](CONTRIBUTORS.md).

> [Website](https://nidkil.me) · GitHub [@nidkil](https://github.com/nidkil) · Twitter [@nidkil](https://twitter.com/nidkil)
