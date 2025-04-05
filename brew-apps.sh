#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Bash 5
brew install bash bash-completion@2
brew install openjdk openjdk@21
brew install jq yq
brew install kube-ps1 kubecolor helm

# Remove outdated versions from the cellar.
brew cleanup
