# Binaries for a Multiuser OS

Guide to installing and sharing command-line tools (e.g. Homebrew-managed binaries like `gh`, `node`) so multiple local users can use them without `sudo`, on a shared macOS (or similar) machine.

## Overview

| Goal | Approach |
|------|----------|
| One install, many users | Put tools in a shared prefix (`/opt/homebrew`, `/usr/local`) and give a dedicated group write access |
| See who can use them | Use a group (e.g. `brewusers`) and add usernames to it |
| No `sudo` for daily use | Correct ownership + `g+w` (and optional setgid) on the install prefix |

---

## 1. List local users

Know which accounts exist before adding them to a shared group.

**All local user accounts (macOS):**

```bash
dscl . list /Users | grep -v '^_'
```

**Only human-style accounts (homedir under /Users):**

```bash
dscl . list /Users | grep -v '^_' | while read u; do
  h=$(dscl . read /Users/"$u" NFSHomeDirectory 2>/dev/null | awk '{print $2}')
  [[ "$h" == /Users/* ]] && echo "$u"
done
```

**Verify a user's groups:**

```bash
groups <username>
```

Pick the usernames that should be allowed to run the shared binaries (e.g. `brew`, `gh`).

---

## 2. Create a shared group

Create a group and add those users. Example name: `brewusers`; use an unused GID (group identifier), e.g. 600. (Tip: `dscl . list /Groups gid`)

```bash
sudo dscl . create /Groups/brewusers
sudo dscl . create /Groups/brewusers gid 600
sudo dscl . create /Groups/brewusers passwd "*" # disable group login
```

Add each user:

```bash
sudo dscl . append /Groups/brewusers GroupMembership jsdario
sudo dscl . append /Groups/brewusers GroupMembership otheruser
# repeat for every user who should use the shared binaries
```

Check:

```bash
dscl . read /Groups/brewusers
```

---

## 3. Shared prefix: ownership and permissions

Use a single prefix where binaries live (here: Homebrew on Apple Silicon). One user is owner; the new group gets write access.

**Apple Silicon Homebrew (`/opt/homebrew`):**

```bash
sudo chown -R jsdario:brewusers /opt/homebrew
sudo chmod -R g+w /opt/homebrew
sudo chmod g+s /opt/homebrew
```

- `chown -R jsdario:brewusers` — owner stays one admin user, group is `brewusers`.
- `chmod -R g+w` — group can write (all members can run `brew install`, etc.).
- `chmod g+s` — setgid so new files under `/opt/homebrew` keep the `brewusers` group.

**Intel Homebrew (`/usr/local`):** use the same pattern with `/usr/local` and your group name.

---

## 4. PATH for each user

Each user needs the prefix's `bin` (and possibly `sbin`) on their `PATH`. For Homebrew, each user's shell config (e.g. `~/.zprofile` or `~/.zshrc`) should have:

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Or manually:

```bash
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
```

Ensure this is in each human user's login/profile so they get the shared binaries by default.

---

## 5. Verify

As another user in the group:

```bash
whoami
groups   # should include brewusers
brew --version
gh --version   # or whichever binary you installed
```

If those run without `sudo`, the multiuser setup is working.

---

## 6. Optional: give users sudo

If you also want these users to run arbitrary commands as root, add them to the **admin** group (macOS):

```bash
sudo dscl . append /Groups/admin GroupMembership otheruser
```

Or: **System Settings → Users & Groups → [user] → Allow user to administer this computer.**

This is independent of the shared-binaries group: one controls “can use sudo”, the other “can use the shared Homebrew/binaries”.

---

## 7. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| “Permission denied” when running `brew install` | User not in group or prefix not group-writable | Add user to `brewusers`, re-run `chown`/`chmod` from section 3 |
| “Command not found” for `brew` or `gh` | `PATH` not set for that user | Add `brew shellenv` or `PATH` line to their `~/.zprofile` / `~/.zshrc` and start a new shell |
| “Unknown macOS version” from Homebrew | Very new/beta macOS | Upgrade Homebrew when possible, or install the binary via official `.pkg`/installer instead of `brew` |

---

## Quick reference

```bash
# List users
dscl . list /Users | grep -v '^_'

# Create group and add users
sudo dscl . create /Groups/brewusers
sudo dscl . create /Groups/brewusers gid 600
sudo dscl . append /Groups/brewusers GroupMembership USERNAME

# Shared Homebrew (Apple Silicon)
sudo chown -R OWNER:brewusers /opt/homebrew
sudo chmod -R g+w /opt/homebrew
sudo chmod g+s /opt/homebrew
```

Replace `OWNER` with the user that should “own” Homebrew (e.g. the main admin), and `USERNAME` with each local account that should use the shared binaries.
