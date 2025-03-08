# Dotfiles for running adblock server on a pizero 2 W 

- Alpine Linux
- unbound DNS server
- Added dcron(optional)

## Changes from default sys mode installation
- adding overlaytmpfs=yes to /boot/cmdline.txt is the straightforward solution for sys mode alpine install
- added a script to write to sdcard /usr/local/bin/write2sdcard
- Uing chrony with default config
- Retaining dcron with default config
- Removed all almost all changes to fstab as using overlay root filesystem now. only boot is ro by default now
- keeping lbu, but not really used as of now

   
## Todo
- Save logs on a syslog server
- Make picam work. currently this requires edge.
- Add services like mqtt
- Check if motion software can work reliably. Earlier this caused pi zero 2 W to hang frequently.

The following is not working.. to investigate further
https://tpaste.us/xDQ1
```
Convert sys mode to diskless

    Set media name to save apkvol in the /etc/lbu/lbu.conf file LBU_MEDIA=mmcblk0p1 (Replace mmcblk0p1 with the correct partition name.)
    Configure /etc/fstab for Diskless Operation
        Ensure the media partition (LBU_MEDIA) is listed with noauto.
        Prevent it from being mounted read-write elsewhere.
        Example: If the media was previously used for /boot. Update /etc/fstab:
            UUID=E8C9-4979 /boot vfat noauto,rw,relatime,fmask=0022,dmask=0022,errors=remount-ro 0 2
            UUID=E8C9-4979 /media/mmcblk0p1 vfat noauto,ro 0 0
        Note: If /boot partition is FAT and was previously mounted automatically, no additional changes are needed for booting the diskless OS.
    Mount Root (/) Filesystem as Read-Only. Update /etc/fstab:
        UUID=8e293498-41d6-4d3a-9832-fb4d3334dcc9 / ext4 ro,relatime 0 1
    Include Additional Files for Persistence outside of etc folder using lbu include command
    Commit Changes & Create apkvol using the command $doas lbu commit
    Reboot the pi into Diskless Mode .. $doas reboot

update packages.. or upgrade to newer release or update kernel on a diskless system with underlying sys mode installation..

    Remount / as Read-Write $doas mount -o remount,rw /
    Remount /boot (If Kernel Update Required) $doas mount -o remount,rw /boot
    Perform Updates finish my updating of apk/change/configure files, update kernel
    Synchronize Disk Writes $doas sync
    Remount as Read-Only $doas mount -o remount,ro / and $doas mount -o remount,ro /boot
    Commit Changes to apkvol $lbu commit
    Reboot $doas reboot
```

## Information on the running system 
```
prabu@pizero2w ~ [1]> rc-status -a 
Runlevel: sysinit
 devfs                                                                                                                     [  started  ]
 dmesg                                                                                                                     [  started  ]
 mdev                                                                                                                      [  started  ]
 hwdrivers                                                                                                                 [  started  ]
Runlevel: boot
 swclock                                                                                                                   [  started  ]
 sysctl                                                                                                                    [  started  ]
 modules                                                                                                                   [  started  ]
 seedrng                                                                                                                   [  started  ]
 hostname                                                                                                                  [  started  ]
 bootmisc                                                                                                                  [  started  ]
 syslog                                                                                                                    [  started  ]
 wpa_supplicant                                                                                                [  started 09:25:13 (0) ]
 networking                                                                                                                [  started  ]
Runlevel: default
 unbound                                                                                                                   [  started  ]
 sshd                                                                                                                      [  started  ]
 crond                                                                                                                     [  started  ]
 ntpd                                                                                                                      [  started  ]
 local                                                                                                                     [  started  ]
Runlevel: shutdown
 savecache                                                                                                                 [  stopped  ]
 killprocs                                                                                                                 [  stopped  ]
 mount-ro                                                                                                                  [  stopped  ]
Runlevel: nonetwork
Dynamic Runlevel: hotplugged
Dynamic Runlevel: needed/wanted
 sysfs                                                                                                                     [  started  ]
 fsck                                                                                                                      [  started  ]
 root                                                                                                                      [  started  ]
 localmount                                                                                                                [  started  ]
Dynamic Runlevel: manual

prabu@pizero2w ~> rc-update -a
             bootmisc | boot                                   
                crond |      default                           
                devfs |                                 sysinit
                dmesg |                                 sysinit
             hostname | boot                                   
            hwdrivers |                                 sysinit
            killprocs |                        shutdown        
                local |      default                           
                 mdev |                                 sysinit
              modules | boot                                   
             mount-ro |                        shutdown        
           networking | boot                                   
                 ntpd |      default                           
            savecache |                        shutdown        
              seedrng | boot                                   
                 sshd |      default                           
              swclock | boot                                   
               sysctl | boot                                   
               syslog | boot                                   
              unbound |      default                           
       wpa_supplicant | boot

prabu@pizero2w ~> doas crontab -l
# do daily/weekly/monthly maintenance
# min	hour	day	month	weekday	command
*/15	*	*	*	*	run-parts /etc/periodic/15min
0	*	*	*	*	run-parts /etc/periodic/hourly
0	2	*	*	*	run-parts /etc/periodic/daily
0	3	*	*	6	run-parts /etc/periodic/weekly
0	5	1	*	*	run-parts /etc/periodic/monthly
0 	2 	* 	* 	0	/usr/local/bin/stevenblack
@reboot sleep 180 && /sbin/rc-service chronyd restart
#0	1	2	*	*	/usr/bin/curl https://www.internic.net/domain/named.cache -o /etc/unbound/root.hints

prabu@pizero2w ~> free -m
              total        used        free      shared  buff/cache   available
Mem:            449         110         248           0          91         328
Swap:             0           0           0
```

steps to create and maintain this git repository:
```
$ git init --bare $HOME/.systemfiles
$ echo "alias sysconfig='git --git-dir=/home/prabu/.systemfiles --work-tree=/'" >> ~/.config/fish/config.fish
$ source ~/.config/fish/config.fish
$ sysconfig config --local status.showUntrackedFiles no
$ sysconfig add /etc/unbound/unbound.conf
$ git config --global user.name "Prabu Anand Kalivaradhan"
$ git config --global user.email "kxxxxxxxxd@gmail.com"
$ git config --global user.signingkey id_ed25519.pub
$ ssh -T git@github.com
$ sysconfig remote add origin git@github.com:prabusw/pizero2W.git
$ sysconfig config --global user.signingkey ~/.ssh/id_ed25519
$ sysconfig commit -m "initial commit"
$ sysconfig remote -v
$ sysconfig push origin master
$ sysconfig push --force origin master
$ doas emacs /.github/README.md
$ sysconfig add /.github/README.md
$ sysconfig commit -m "added README.md"
$ sysconfig push origin master
```
