#!/bin/sh

exec flatpak run --command=brave com.brave.Browser --enable-features=UseOzonePlatform --ozone-platform=wayland --profile-directory=Profile-Personal --app-id=lodlkdfmihgonocnmddehnfgiljnadcf
