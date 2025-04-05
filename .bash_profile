# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH:/opt/homebrew/bin/";

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

# Source bash-completion@2 if available
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

if [ -d $(brew --prefix)/etc/bash_completion.d ]; then
    for bcfile in $(brew --prefix)/etc/bash_completion.d/*; do
        [ -f "$bcfile" ] && . "$bcfile"
    done
fi

export GRADLE_COMPLETION_UNQUALIFIED_TASKS="true"

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
export FLUTTER_SUPPRESS_ANALYTICS=false
export ANDROID_HOME=${HOME}/Library/Android/sdk
export FLUTTER_HOME=${HOME}/softwares/flutter
export PATH=./:${PATH}:/usr/local/bin:
export PATH=${PATH}:${FLUTTER_HOME}/bin:
export PATH=${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin

export JAVA_HOME=`/usr/libexec/java_home -v 21.0.6`
export PATH=$JAVA_HOME/bin:$PATH

eval "$(/opt/homebrew/bin/brew shellenv)"

# Load secrets into environment variables
source ~/.my-env-vars-and-secrets