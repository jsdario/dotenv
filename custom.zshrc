# wt - Git Worktree helper                                                                                        
# Creates a worktree at ../repo-branch and cd's into it                                                           
#                                                                                                                 
# Usage:                                                                                                          
#   wt               move current branch to new worktree, switch original to main
#   wt <branch>      checkout existing branch in new worktree
#   wt -b <branch>   create new branch and worktree
wt() {
  local repo=$(basename "$(git rev-parse --show-toplevel)")
  local current=$(git symbolic-ref --short HEAD)
  local branch="${@: -1}"
  if [[ $# -eq 0 || "$branch" == "$current" ]]; then
    # No args or current branch: detach, reattach in new worktree, switch original to main
    branch="$current"
    git worktree add --detach "../${repo}-${branch}" || return 1
    git -C "../${repo}-${branch}" checkout "$branch" || return 1
    git checkout main
  else
    # Different or new branch: standard worktree add (supports -b flag)
    git worktree add "../${repo}-${branch}" "$@" || return 1
  fi
  # cd into the new worktree
  cd "../${repo}-${branch}"
}
