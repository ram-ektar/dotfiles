#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin main;

function update_env_vars() {
	local template_file=".my-env-vars-and-secrets-template"
	local output_file="$HOME/.my-env-vars-and-secrets"
	local backup_file="$HOME/.my-env-vars-and-secrets-$(date +%Y-%m-%d-%H-%M-%S).backup"
	
	# Create backup of existing file if it exists
	if [[ -f "$output_file" ]]; then
		echo "Creating backup of existing .my-env-vars-and-secrets file to $backup_file"
		cp "$output_file" "$backup_file"
	fi
	
	echo "Updating environment variables in $output_file from current environment..."
	
	# Clear the output file if it exists
	> "$output_file"
	
	# Read the template file line by line
	while IFS= read -r line; do
		# Add comment lines and empty lines and
		if [[ "$line" =~ ^#.*$ || -z "$line" ]]; then
			echo "$line" >> "$output_file"
			continue
		fi
		
		# Extract the variable name for export lines
		if [[ "$line" =~ ^export\ ([A-Za-z0-9_]+)= ]]; then
			var_name="${BASH_REMATCH[1]}"
			var_value="${!var_name}"
			
			# If the environment variable exists, use its value
			if [[ -n "$var_value" ]]; then
				echo "export $var_name=\"$var_value\"" >> "$output_file"
			else
				# Keep the original line if no environment value is found
				echo "$line" >> "$output_file"
			fi
		else
			# Keep any other lines as they are
			echo "$line" >> "$output_file"
		fi
	done < "$template_file"
	
	# Set proper permissions
	chmod 600 "$output_file"
	echo "Environment variables updated successfully! File saved to $output_file"
}

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;

	update_env_vars;
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
echo '6.  To update env vars from current environment, run ./bootstrap.sh --update-env'
echo '7.  Import iTerm2-Profile-Settings.json to iTerms'
