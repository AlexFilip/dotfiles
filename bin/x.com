#!/bin/sh

exec flatpak run --command=brave com.brave.Browser --profile-directory=Profile-Personal --app-id=lodlkdfmihgonocnmddehnfgiljnadcf