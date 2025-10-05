# My Developer Environment

Begin with Homebrew or zsh depending on what you are looking for. Use `mas` to install the apps that you are missing and you will be good to go 🎉 Still looking to automate vscode and sublime-text plugin installation

## Oh My Zsh
```
ssh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Use `nano` instead of `vim`
I'm not apologetic. Never bothered to learn vim.
```
echo 'export EDITOR=nano' >> ~/.zshrc
```

## Install Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```
# Puts homebrew binaries at the front of the system PATH.
export PATH=$(brew --prefix)/bin:$PATH
```

## Install missing apps
```
# MacOS stats for the menu bar
brew install --cask stats

# Command line App Store installer
brew install mas
mas lucky slack
mas lucky 1Password
mas lucky WhatsApp
mas lucky amphetamine # lately I just type `caffeinate -d` on the terminal
```

I use [Itsycal](https://www.mowglii.com/itsycal/) as a calendar Mac OS extension which is nice <3
Link to [mas-cli/mas](https://github.com/mas-cli/mas) App Store installer

### Zsh improvements
* Frequency-based cd https://github.com/rupa/z
* A plugin I developed myself https://github.com/jsdario/vpn-hint
* Syntax Highlight `cd ~/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git` + `source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`

## Git Configuration

To open git config files just type `git config -e --global`

```
[user]
  name = jsdario
  email = personal@email.com
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
  cp = cherry-pick
  st = status
  br = branch --sort=-committerdate --format='%(HEAD) %(refname:short)  %(committerdate:relative)'
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
  amend = commit -a --amend --no-edit
  unstash = stash pop
[branch]
  autoSetupMerge = always
[merge]
  ff = true
```

Use git pr to create a [Pull Request directly on github](https://github.com/jd/git-pull-request). If 2FA is activated you must [create a token](https://github.com/settings/tokens) and use it as password

```
brew install python3
pip3 install git-pull-request
# You may need to create a .netrc file with credentials
```

## To have [fancy diffs](https://github.com/so-fancy/diff-so-fancy):
```
npm i -g diff-so-fancy
git diff --color | diff-so-fancy | less --tabs=4 -RFX
```

And to setup:
```
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
```

## To have [fancy cat](https://mobile.twitter.com/mgechev/status/1131626715267178496)
```
pip3 install pygments
alias ccat='pygmentize -f terminal256 -O style=native -g'
```

## The Silver Searcher

```
brew install the_silver_searcher
```

# Editors

## Sublime
https://www.sublimetext.com and https://www.sublimemerge.com/download
```
brew install --cask sublime-merge
brew install --cask sublime-text
```

For manual installs, link the binary to a folder in $PATH so you can run it from the command line
```
ln -s "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" ~/bin/smerge
```

## Sublime Packages
- [Naomi](https://packagecontrol.io/packages/Naomi)
- [FileIcons](https://packagecontrol.io/packages/FileIcons)
- [SideBarEnhancements](https://packagecontrol.io/packages/SideBarEnhancements)
- [SyncedSideBar](https://packagecontrol.io/packages/SyncedSideBar)
- [GitHub Flavored Markdown Preview](https://packagecontrol.io/packages/GitHub%20Flavored%20Markdown%20Preview)
