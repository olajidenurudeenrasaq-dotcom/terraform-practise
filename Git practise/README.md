# Git practice: add, remove, commit, and push

Use these files to practice Git in small steps. Run the commands from the
repository root (`terraform-practise`) in PowerShell. Nothing has been staged,
committed, or pushed for you.

## 1. Check the repository

```powershell
git status
git branch --show-current
git remote -v
```

`git status` shows which files Git knows about and whether they are staged.
`git remote -v` shows where a push would go; this repository currently has no
remote configured.

## 2. Add the practice files

First, look at the files in this folder. Then stage them and check what will be
included in your commit:

```powershell
git add "Git practise"
git status
git diff --cached
```

If the staged files look right, make your first commit:

```powershell
git commit -m "Add Git practice files"
git status
```

A commit saves a snapshot locally. It does not push anything to GitHub.

## 3. Remove a tracked file

`remove-me.txt` is included so you can practice removing a file that Git is
already tracking. `git rm` deletes the file and stages that deletion:

```powershell
git rm "Git practise\remove-me.txt"
git status
git diff --cached
git commit -m "Remove practice file"
```

## 4. Push your commits

There is no remote configured in this repository yet. Create an empty
repository on your Git hosting service, copy its repository URL, and replace
`<YOUR_REPOSITORY_URL>` below with that URL:

```powershell
git remote add origin <YOUR_REPOSITORY_URL>
git push -u origin main
```

Keep the URL in quotes if it contains characters PowerShell might interpret.
If `git remote -v` already shows an `origin`, don't add it again; use
`git remote set-url origin <YOUR_REPOSITORY_URL>` if you need to change it.
The `-u` option connects your local `main` branch to the remote branch, so
later you can usually push with just `git push`.

## Useful checks

```powershell
git status
git log --oneline
git remote -v
```

If Git asks who you are before committing, set your commit identity (use your
own name and email):

```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
