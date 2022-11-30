#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
	source ~/.docker-base-completion.sh;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

echo -e "\n\n-------------------------------------"
echo "Next steps..."
echo "-------------------------------------"
echo "1. Install brew [ Refer to https://brew.sh/ ]"
echo "2. Install bash & bash-completion@2 latest version [ brew install bash bash-completion@2 ]"
echo "3. Install openjdk [brew install openjdk]"
echo "4. Install jp - [brew install jq]"
echo "5. Install kube-ps1 - [brew install kube-ps1]"
echo "6. Install flutter @ $HOME/softwares/flutter directory "
echo "7. Install gcloud-cli @ $HOME/softwares/gcloud-sdk directory [Refer to https://cloud.google.com/sdk/docs/install-sdk ]"
echo "8. Copy all gcloud auth json files to $HOME/.gcloud-key-files/ directory "
echo "9. Set global git configs"
ehco '      git config --global user.email "you@example.com"'
echo '      git config --global user.name "Your Name"'
echo '      git config --global --add commit.gpgsign false'
