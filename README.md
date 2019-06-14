# My Developer Environment

## Oh My Zsh
```
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### Zsh improvements
* Frequency-based cd https://github.com/rupa/z
* A plugin I developed myself https://github.com/jsdario/vpn-hint
* Syntax Highlight `cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git` + `source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`

## Git Configuration

> To open git config files just type `git config -e --global`

* Large File Support
* Use `git pr` to [create a Pull Request directly on github](https://github.com/jd/git-pull-request). If 2FA is activated you must [create a token](https://github.com/settings/tokens) and use it as password.

```
brew install python3
pip3 install git-pull-request
# You may need to create a .netrc file with credentials
```

* Autotrack branches so `git push` and `git pull` work with the matching remote branch out-of-the-box
* Colors
* Works well with zsh
* Aliases:
  * ci = commit
  * co = checkout
    * Use the `--force | -f` switch to discard local changes
  * st = status
  * br = branch
  * lg = log # with colors
  * pl = pull --rebase
  * rem = remote
  * `git ls` Will list all remotes with their URLs
  * `git undo` will uncommit the last commit
    * Use `--hard` to stash dirty directory after a soft undo
  * sm = submodule
  * pr = pull-request --target-branch master
  * Fast forward on merges by default
  * `git conflicts` shows conflicting files on a merge or rebase
  * `git compare` shows the diff from the current branch w/ master
    * use `--name-only` if you don't care for the particular lines


```
[user]
  name = jsdario
  email = jesus@netbeast.co
[core]
  editor = nano
  excludesfile = /Users/jdario/.gitignore_global
[filter "lfs"]
  process = git-lfs filter-process
  required = true
  clean = git-lfs clean -- %f
  smudge = git-lfs smudge -- %f
[push]
  default = current
[alias]
  ci = commit
  co = checkout
  st = status
  br = branch
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%Creset' --abbrev-commit
  graph = log --graph --all '--pretty=format:%Cred%h%Creset %ad | [%C(bold blue)%an%Creset] %Cgreen%d%Creset %s' --date=iso
  rem = remote
  ls = rem -v
  pl = pull --rebase
  sm = submodule
  pr = pull-request --target-branch master
  undo = reset --soft HEAD^
  conflicts = !git ls-files -u | cut -f 2 | sort -u
  compare = !git diff master..."$(git symbolic-ref --short HEAD)"
  
[merge]
        ff = true
[pull]
  default = current
```

## To have [fancy diffs](https://github.com/so-fancy/diff-so-fancy):
```
npm i -g diff-so-fancy
git diff --color | diff-so-fancy | less --tabs=4 -RFX
```

### Setup
```
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
```

## To have [fancy cat](https://mobile.twitter.com/mgechev/status/1131626715267178496)
```
pip3 install pygments
alias ccat='pygmentize -f terminal256 -O style=native -g'
```

## Sublime Packages
- [Naomi](https://packagecontrol.io/packages/Naomi)
- [FileIcons](https://packagecontrol.io/packages/FileIcons)
- [SideBarEnhancements](https://packagecontrol.io/packages/SideBarEnhancements)
- [SyncedSideBar](https://packagecontrol.io/packages/SyncedSideBar)
- [GitHub Flavored Markdown Preview](https://packagecontrol.io/packages/GitHub%20Flavored%20Markdown%20Preview)
