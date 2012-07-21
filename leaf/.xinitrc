
setterm -blank 0 -powersave off -powerdown 0
xset s off

export BROWSER=seamonkey
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec ck-launch-session dbus-launch openbox-session
