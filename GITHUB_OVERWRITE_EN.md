# Replace the existing hoho-consciousness-engine repository

## Recommended method

Copy every file from this package into your existing local
`hoho-consciousness-engine` repository.

Create a backup branch first:

```powershell
git status
git branch backup-before-julia-rewrite
```

Remove old tracked files:

```powershell
git rm -r .
```

Copy the new files into the repository, then run:

```powershell
git add .
git commit -m "Rewrite engine in Julia with bilingual Black Swan documentation"
git push origin main
```

The previous Python version will remain available in Git history.

`README.md` is the Japanese version.  
`README_EN.md` is the English version.
