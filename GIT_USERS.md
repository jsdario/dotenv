# Git Identity (github-bot)

This repo uses a **github-bot**-style GitHub user for commits and pushes. Follow this guide to configure your local clone.

## Checklist

- [ ] Set commit author: `git config user.name "github-bot"` and `user.email "your-bot@example.com"`
- [ ] Create or choose an SSH key and add the public key to the github-bot GitHub account (`cat ~/.ssh/id_ed25519_github_bot.pub | pbcopy`)
- [ ] Add `Host github-bot` block to `~/.ssh/config` and set `git remote set-url origin git@github-bot:owner/repo.git` (this repo: `coral-bot/coral.to`)
- [ ] Verify: `ssh -T git@github-bot` → expect `Hi github-bot! You've successfully authenticated...`

---

## 1. Commit author

Set the author for this repo only (does not change your global git config):

```bash
git config user.name "github-bot"
git config user.email "your-bot@example.com"
```

## 2. SSH key for github-bot

GitHub identifies you by the SSH key you use. To push as github-bot, use a key that is added to the github-bot GitHub account.

### Use an existing key

List keys and show the public one to add in GitHub (Settings → SSH and GPG keys):

```bash
ls -la ~/.ssh
cat ~/.ssh/<your-github-bot-key>.pub | pbcopy   # copy to clipboard, then paste in GitHub
```

### Generate a new key

```bash
ssh-keygen -t ed25519 -C "your-bot@example.com" -f ~/.ssh/id_ed25519_github_bot
```

Then copy the public key and add it to the github-bot account:

```bash
cat ~/.ssh/id_ed25519_github_bot.pub | pbcopy
```

Add it in GitHub (logged in as github-bot): **Settings → SSH and GPG keys → New SSH key**.

## 3. Push as github-bot

Point SSH at the github-bot key when talking to GitHub from this repo.

**In `~/.ssh/config`** add (adjust `IdentityFile` if your key has another path):

```
Host github-bot
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github_bot
  IdentitiesOnly yes
```

**In this repo**, set origin to use that host:

```bash
git remote set-url origin git@github-bot:owner/repo.git
```

For this repo use: `git@github-bot:coral-bot/coral.to.git`.

`IdentitiesOnly yes` makes SSH use only this key for `github-bot`, not your default key.

## 4. Verify

Test the SSH connection:

```bash
ssh -T git@github-bot
```

You should see: `Hi github-bot! You've successfully authenticated...`

Then push as usual; GitHub will attribute the push to github-bot.
