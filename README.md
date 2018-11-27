# My .gitconfig

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
  * st = status
  * br = branch
  * lg = log # with colors
  * pl = pull --rebase
  * undo = reset --soft HEAD^ 
  * `undo --hard` will stash dirty directory after a soft undo
  * sm = submodule
  * pr = pull-request --target-branch master
* Fast forward on merges by default


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
  pl = pull --rebase
  sm = submodule
  pr = pull-request --target-branch master
  undo = reset --soft HEAD^
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

