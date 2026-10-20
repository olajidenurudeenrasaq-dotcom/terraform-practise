# Git practice: branches, syncing, and recovery

God is helping me to learn git

This lesson builds on your first commit. Run commands from the repository root
(`terraform-practise`) in PowerShell. The repository currently has a `main`
branch and an `origin` remote, so you can practice both local branches and
remote syncing.

First save and publish this lesson so the working tree is clean for the
exercises:

```powershell
git status
git add "Git practise"
git diff --cached
git commit -m "Add branching and pulling lesson"
git push
```

Read the staged diff before committing. If `git status` shows changes outside
this practice folder that you didn't intend to include, don't use `git add .`;
stage only the files you mean to commit.

Before each exercise, check that your working tree is clean:

```powershell
git status
```

If you have changes you want to keep, commit or stash them before switching
branches. A clean status should say `nothing to commit, working tree clean`.

## 1. Branches: work without changing `main`

A branch is a movable name pointing to a commit. `HEAD` tells Git which branch
or commit you currently have checked out. Create and switch to a new branch:

```powershell
git switch main
git pull --ff-only
git switch -c practice/feature
git branch
git status
```

The `*` in `git branch` marks your current branch. `-c` creates the branch and
switches to it. Now create a file for the feature:

```powershell
notepad "Git practise\feature-note.txt"
```

Write a short note, save, and close Notepad. Then review and commit it:

```powershell
git status
git diff
git add "Git practise\feature-note.txt"
git diff --cached
git commit -m "Add feature note"
```

Switch back to `main` and check that the feature file is not there. Merge the
feature branch into `main`:

```powershell
git switch main
git status
git merge practice/feature
git log --oneline --graph --decorate --all
```

The merge brings the feature's commit into `main`. Because this feature added a
new file, it should merge without a conflict. After confirming the merge, you
can remove the now-merged local branch:

```powershell
git branch -d practice/feature
```

## 2. Conflicts: resolve two edits to the same line

A conflict is Git asking you to choose how overlapping changes should fit
together. Start by making a dedicated practice file on `main`:

```powershell
git switch main
notepad "Git practise\conflict-lab.txt"
```

Put this single line in the file, save it, and commit the starting point:

```text
Status: original
```

Now change that line on a branch and commit it:

```powershell
git switch -c practice/conflict
notepad "Git practise\conflict-lab.txt"
```

Replace the line with `Status: changed on feature`, save, and run:

```powershell
git add "Git practise\conflict-lab.txt"
git commit -m "Change status on feature"
git switch main
notepad "Git practise\conflict-lab.txt"
```

On `main`, replace the same original line with `Status: changed on main`,
save, and commit:

```powershell
git add "Git practise\conflict-lab.txt"
git commit -m "Change status on main"
git merge practice/conflict
```

The merge reports a conflict. Open the file: Git has marked the current
branch's version and the incoming branch's version, with lines beginning with
`<<<<<<<`, `=======`, and `>>>>>>>` to label the sections. Edit the file to
the final content you want and remove those marker lines. Then mark the
conflict resolved and finish the merge:

```powershell
git add "Git practise\conflict-lab.txt"
git status
git commit
git log --oneline --graph --decorate --all
```

Git opens an editor with a suggested merge-commit message; save and close it
to complete the merge. If you want to cancel before completing the merge, use
`git merge --abort`.

## 3. Fetch vs. pull: see remote changes before integrating them

`origin` is the usual nickname for your remote repository. `origin/main` is
your local record of the remote's `main` branch; it only updates when you
fetch. To make a safe pull exercise, first push your local commits:

```powershell
git switch main
git push
```

On your Git hosting website, edit a small line in the README and commit that
change to `main`. Back in your terminal, fetch without changing your files:

```powershell
git fetch origin
git status -sb
git log --oneline --graph --decorate --all -8
```

You should see that `origin/main` has advanced. `git fetch` downloads remote
commits and updates remote-tracking branches, but does not merge them into
your current branch. Integrate the update with:

```powershell
git pull --ff-only
```

`git pull` is fetch plus integration. `--ff-only` allows a simple
fast-forward but stops rather than creating a merge commit if your local and
remote histories have diverged. If it stops, inspect `git status` and the
graph before deciding whether to merge or rebase.

When your local branch has commits that are not on the remote, publish them
with:

```powershell
git push
```

`git push -u origin branch-name` sets an upstream the first time you publish
a new branch. After that, `git push` and `git pull` can usually infer the
remote branch.

## 4. Deeper practice: rebase a private branch

Rebase replays your branch's commits on top of another branch. It can make
history look linear, but it creates new commit IDs. Only do this to commits
that you have not shared with others.

Start a local feature branch and commit a file:

```powershell
git switch main
git switch -c practice/rebase
notepad "Git practise\rebase-note.txt"
```

Write a note, save it, then commit:

```powershell
git add "Git practise\rebase-note.txt"
git commit -m "Add rebase note"
```

Create a separate commit on `main` while the feature branch is waiting:

```powershell
git switch main
notepad "Git practise\conflict-lab.txt"
```

Add a new line (don't replace the existing one), save, and commit:

```powershell
git add "Git practise\conflict-lab.txt"
git commit -m "Add another main note"
```

Replay your feature commit on the updated `main`, then fast-forward `main`:

```powershell
git switch practice/rebase
git rebase main
git log --oneline --graph --decorate --all
git switch main
git merge --ff-only practice/rebase
git branch -d practice/rebase
```

If a rebase has a conflict, edit the file to the desired content, then run
`git add <file>` followed by `git rebase --continue`. To abandon the rebase and
return to how the branch was before it started, run `git rebase --abort`.

## 5. Recovery and history tools

These commands inspect history without changing it:

```powershell
git diff
git diff --cached
git show --stat
git log --oneline --graph --decorate --all
git reflog
```

`git reflog` records where your local `HEAD` and branches recently pointed,
which can help find a commit after moving a branch by mistake.

For undoing work, choose based on whether it has been shared:

- `git revert <commit>` makes a new commit that undoes an earlier commit. It
  is the safer choice for commits already pushed or shared.
- `git reset` moves the current branch pointer. It can be useful for local,
  unpublished work, but `--hard` also discards working-tree changes. Avoid it
  unless you understand exactly what will be lost.
- `git restore <file>` discards uncommitted changes to a file. Review
  `git status` and `git diff` first; discarded edits may be difficult to
  recover.

Check your progress at any time:

```powershell
git status -sb
git branch -avv
git log --oneline --graph --decorate --all
```
