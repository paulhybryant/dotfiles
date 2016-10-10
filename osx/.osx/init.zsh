#!/usr/bin/env zsh

sudo -v

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

defaults write com.apple.finder AppleShowAllFiles YES

${0:h}/karabiner-import.sh
${0:h}/seil-import.sh
${0:h}/spectacle-import.sh


# /System/Library/PrivateFrameworks/DiskImages.framework/Versions/A/Resources/agent-defaults/finder.plist
# /Library/Managed Preferences/yuhuang/com.googlecode.iterm2.plist
# /Applications/Karabiner.app/Contents/Library/bin/karabiner export
# /Applications/Karabiner.app/Contents/Library/bin/seil export
# Shortcuts.json from ~/Library/Application Support/Spectacle/
