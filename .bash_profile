# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Add more tab completion as many as possible
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Ram's customizations
export FLUTTER_HOME=${HOME}/softwares/flutter
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=./:${PATH}:/usr/local/bin:${FLUTTER_HOME}/bin:/opt/homebrew/opt/openjdk/bin:/opt/homebrew/bin:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=/opt/homebrew/opt/openjdk/bin:$HOME/softwares/flutter/bin:$PATH:/opt/homebrew/bin:

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/softwares/google-cloud-sdk/path.bash.inc' ]; then . '$HOME/softwares/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/softwares/google-cloud-sdk/completion.bash.inc' ]; then . '$HOME/softwares/google-cloud-sdk/completion.bash.inc'; fi

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
# Google Artifactory settings for publishing images
export GOOGLE_APPLICATION_CREDENTIALS=${HOME}/.gcloud-key-files/daas-nonprod-project-daas-ci-admin-key.json

source <(kubectl completion bash)

# Github container registry settings for publishing images
export GITHUB_USERNAME=ram-ektar
export GITHUB_PAT=

#alias
alias flutter-json-seriable-run='flutter pub run build_runner build --delete-conflicting-outputs'
alias flutter-watch-json-seriable='flutter pub run build_runner watch --delete-conflicting-outputs'
