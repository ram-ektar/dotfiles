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
	cp .my-env-vars-and-secrets-template ~/.my-env-vars-and-secrets;
	chmod 600 ~/.my-env-vars-and-secrets;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
		cp .my-env-vars-and-secrets-template ~/.my-env-vars-and-secrets;
		chmod 600 ~/.my-env-vars-and-secrets;
	fi;
fi;
unset doIt;

echo -e '\n\n-------------------------------------'
echo 'Next steps...'
echo '-------------------------------------'
echo '1.  Install brew [ Refer to https://brew.sh/ ]'
echo '2.  Download & import snazzy iterm color [https://github.com/sindresorhus/iterm2-snazzy]'
echo '3.  Run ./brew-apps.sh to install all the brew dependencies'
echo '4.  Set global git configs'
echo '      git config --global user.email "you@example.com"'
echo '      git config --global user.name "Your Name"'
echo '5.  Edit .my-secrets add your secrets'
