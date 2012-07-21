#!/bin/bash
## reinstall from github backup! =)
## 03-22-2012 pdq


my_home="/home/leaf/"
my_backup="/media/sf_Upload/arch_backup/"
#my_home="/home/pdq/test/"
save_directory="save"
dev_directory="Dev"
dotfiles="${dev_directory}/dotfiles/"
#dotfiles_main="${my_home}${dotfiles}main.lst"
#dotfiles_local="${my_home}${dotfiles}local.lst"

dotfiles_main="a_main.lst"
dotfiles_local="a_local.lst"

#dotfiles_repo="git://github.com/idk/dotfiles.git"
dotfiles_repo="git://github.com/LeafG/dotfiles.git"
done_format="=========================================\n"
choice_count=10
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # Colored
txtrst=$(tput sgr0) # Reset

if [ `id -u` -eq 0 ]; then
echo "${bldred}Do not run me as root!${txtrst} =)"
   exit
fi

function menulist() {
   echo "1. Create ${my_home}${dotfiles} and ${my_home}vital/pkg/"
   echo "2. Git clone backup to dotfiles"
   echo "3. Backup mirrorlist and write/rank/sort new mirrorlist"
   echo "4. Install main packages"
   echo "5. Install AUR packages --noconfirm"
   echo "6. Install AUR packages"
   echo "7. Backup and copy user configs"
   echo "8. Backup and copy root configs"
   echo "9. Exit Installer"
   echo -n "${txtbld}Please choose [1,2,3,4,5,7,8 or 9] ?${txtrst} "
   # Loop while the variable choice is equal $choice_count
}

# Declare variable choice and assign value $choice_count
choice=$choice_count
# Print to stdout
#menulist
# bash while loop
while [ $choice -eq $choice_count ]; do
menulist
   # read user input
   read choice
   # bash nested if/else
   if [ $choice -eq 1 ] ; then
echo "${txtbld}Creating ${my_home}${dotfiles}${txtrst}"
      cd ${my_home}
      mkdir ${dev_directory}
      cd ${my_home}${dev_directory}
      pwd
echo "${txtbld}Creating ${my_home}vital/${txtrst}"
      cd ${my_home}
      mkdir vital
      cd ${my_home}vital
      pwd
echo "${txtbld}Creating ${my_home}vital/pkg/${txtrst}"
      cd ${my_home}vital
      mkdir pkg
      cd ${my_home}vital/pkg
      pwd
choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 2 ] ; then
echo "${txtbld}Git clone backup to dotfiles${txtrst}"
      ## my backups repo
      cd ${my_home}${dev_directory}
      git clone $dotfiles_repo
      cd ${my_home}${dotfiles}
      pwd
ls -a
      choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 3 ] ; then
echo "${txtbld}Backing up mirrorlist and write/rank/sort new mirrorlist${txtrst}"
      sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
      sudo cp -p ${my_home}${dotfiles}etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
      choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 4 ] ; then
echo "${txtbld}Installing main packages${txtrst}"
      ## Installing backups on guest
      ## Install offical packages
      sudo pacman -S --needed $(cat $dotfiles_main)
      choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 5 ] ; then
echo "${txtbld}Installing AUR packages${txtrst}"
      ## Install non-official (local) packages
      yaourt --noconfirm -S $(cat $dotfiles_local | grep -vx "$(pacman -Qqm)")
      choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 6 ] ; then
echo "${txtbld}Installing AUR packages${txtrst}"
      ## Install non-official (local) packages
      yaourt -S $(cat $dotfiles_local | grep -vx "$(pacman -Qqm)")
      choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 7 ] ; then
echo "${txtbld}Backing up and copying user configs${txtrst}"
      mv ${my_home}.gtkrc-2.0 ${my_home}.gtkrc-2.0.bak
      cp -p ${my_home}${dotfiles}.gtkrc-2.0 ${my_home}.gtkrc-2.0
      mv ${my_home}.bashrc ${my_home}.bashrc.bak
      cp -p ${my_home}${dotfiles}.bashrc ${my_home}.bashrc
      mv ${my_home}.Xresources ${my_home}.Xresources.bak
      cp -p ${my_home}${dotfiles}.Xresources ${my_home}.Xresources
      cp -p ${my_home}${dotfiles}.conkyrc ${my_home}.conkyrc
      cp -p ${my_home}${dotfiles}.xinitrc ${my_home}.xinitrc
      cp -p ${my_home}${dotfiles}conky_clock.sh ${my_home}conky_clock.sh
      chmod +x /home/leaf/.xinitrc
      chmod +x /home/leaf/conky_clock.sh
      cp -rp ${my_home}${dotfiles}.config/. ${my_home}.config/.
      cp -rp ${my_home}${dotfiles}Desktop/. ${my_home}Desktop/.
      chmod +x /home/leaf/.config/openbox/pipemenus/*.sh
      cp -rp ${my_home}${dotfiles}conky ${my_home}conky
      echo "
mv ${my_home}.gtkrc-2.0 ${my_home}.gtkrc-2.0.bak
cp -p ${my_home}${dotfiles}.gtkrc-2.0 ${my_home}.gtkrc-2.0
mv ${my_home}.bashrc ${my_home}.bashrc.bak
cp -p ${my_home}${dotfiles}.bashrc ${my_home}.bashrc
mv ${my_home}.Xresources ${my_home}.Xresources.bak
cp -p ${my_home}${dotfiles}.Xresources ${my_home}.Xresources
cp -p ${my_home}${dotfiles}.conkyrc ${my_home}.conkyrc
cp -p ${my_home}${dotfiles}.xinitrc ${my_home}.xinitrc
cp -p ${my_home}${dotfiles}conky_clock.sh ${my_home}conky_clock.sh
chmod +x /home/leaf/.xinitrc
chmod +x /home/leaf/conky_clock.sh
cp -rp ${my_home}${dotfiles}.config/. ${my_home}.config/.
chmod +x /home/leaf/.config/openbox/pipemenus/*.sh
cp -rp ${my_home}${dotfiles}conky ${my_home}conky
cp -rp ${my_home}${dotfiles}Desktop/. ${my_home}Desktop/.
"
cd ${my_home}
      pwd
ls -a
      choice=$choice_count
      echo -e $done_format
    elif [ $choice -eq 8 ] ; then
echo "${txtbld}Backing up and copying root configs${txtrst}"
      sudo mv /etc/rc.conf /etc/rc.conf.bak
      sudo cp -p ${my_home}${dotfiles}etc/rc.conf /etc/rc.conf
#      sudo cp ${my_home}${dotfiles}etc/mpd.conf /etc/mpd.conf
#      ln -s /etc/mpd.conf ${my_home}.mpdconf
      sudo mv /etc/pacman.conf /etc/pacman.conf.bak
      sudo cp -p ${my_home}${dotfiles}etc/pacman.conf /etc/pacman.conf
      sudo cp -p ${my_home}${dotfiles}etc/sudoers.d/g_wheel /etc/sudoers.d/g_wheel
      sudo chmod 440 /etc/sudoers.d/g_wheel
      sudo chown root:root /etc/sudoers.d/g_wheel
      sudo mv /etc/slim.conf /etc/slim.conf.bak
      sudo cp -p ${my_home}${dotfiles}etc/slim.conf /etc/slim.conf
      sudo mv /etc/xdg/menus /etc/xdg/menus.bak
      sudo cp -rp ${my_home}${dotfiles}etc/xdg/menus/ /etc/xdg/menus/
      sudo cp -rp ${my_home}${dotfiles}usr/share/. /usr/share/.
      sudo mv /etc/oblogout.conf /etc/oblogout.conf.bak
      sudo cp -p ${my_home}${dotfiles}etc/oblogout.conf /etc/oblogout.conf
      echo "
sudo mv /etc/rc.conf /etc/rc.conf.bak
sudo cp -p ${my_home}${dotfiles}etc/rc.conf /etc/rc.conf
#sudo cp ${my_home}${dotfiles}etc/mpd.conf /etc/mpd.conf
#ln -s /etc/mpd.conf ${my_home}.mpdconf
sudo mv /etc/pacman.conf /etc/pacman.conf.bak
sudo cp -p ${my_home}${dotfiles}etc/pacman.conf /etc/pacman.conf
sudo cp -p ${my_home}${dotfiles}etc/sudoers.d/g_wheel /etc/sudoers.d/g_wheel
sudo chmod 440 /etc/sudoers.d/g_wheel
sudo chown root:root /etc/sudoers.d/g_wheel
sudo mv /etc/slim.conf /etc/slim.conf.bak
sudo cp -p ${my_home}${dotfiles}etc/slim.conf /etc/slim.conf
sudo mv /etc/xdg/menus /etc/xdg/menus.bak
sudo cp -rp ${my_home}${dotfiles}etc/xdg/menus/ /etc/xdg/menus/
sudo cp -rp ${my_home}${dotfiles}usr/share/. /usr/share/.
sudo mv /etc/oblogout.conf /etc/oblogout.conf.bak
sudo cp -p ${my_home}${dotfiles}etc/oblogout.conf /etc/oblogout.conf"
      cd /etc
      pwd
choice=$choice_count
      echo -e $done_format
   elif [ $choice -eq 9 ] ; then
echo -e $done_format
      echo "${bldred}See ya!${txtrst}"
      exit
else
echo "${bldred}Please make a choice between 1-9 !${txtrst} "
      menulist
      choice=$choice_count
   fi
done
## Creating backups on host
## Create main.lst remove local, base
# pacman -Qqe | grep -vx "$(pacman -Qqg base)" | grep -vx "$(pacman -Qqm)" > main.lst
## Create local.lst of local (includes AUR) packages installed
# pacman -Qqm > local.lst
## end
