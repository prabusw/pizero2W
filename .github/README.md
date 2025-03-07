# Dotfiles for pizero 2 W running adblock server.

## Changes from default sys mode installation
- Changed fstab to make / and /boot as readonly
- Added lbu to keep track of files 
- Replaced chrony by busybox ntpd due to issues with drift file.
- Edited fstab to make /var/log as tmps filesystem so syslogs does not keep writing to sdcard

## Todo
- Save logs on a syslog server
- Make picam work. currently this requires edge.
- Add services like mqtt
- Check if motion software can work reliably. Earlier this caused pi zero 2 W to hang frequently.

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