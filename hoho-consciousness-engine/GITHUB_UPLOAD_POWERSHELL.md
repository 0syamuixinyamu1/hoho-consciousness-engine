# GitHub upload from PowerShell

Open PowerShell in the extracted repository folder.

```powershell
git init
git add .
git commit -m "Initial release: HOHO Black Swan consciousness engine"
git branch -M main
git remote add origin https://github.com/YOUR_NAME/hoho-consciousness-engine.git
git push -u origin main
```

For later updates:

```powershell
git add .
git commit -m "Update consciousness model"
git push
```

Keep `README.md` directly in the repository root so GitHub displays it on the top page.
