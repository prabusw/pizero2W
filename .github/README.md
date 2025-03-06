Dotfiles for pizero 2 W running adblock server

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