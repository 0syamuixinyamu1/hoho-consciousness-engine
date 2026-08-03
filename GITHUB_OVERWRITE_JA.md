# 既存のhoho-consciousness-engineをJulia版で上書きする

## 方法A: 既存フォルダを直接置き換える

このZIPの中身をすべて、ローカルの既存リポジトリ
`hoho-consciousness-engine` の中へコピーする。

古いPythonファイルを残したくない場合は、PowerShellで既存フォルダへ移動してから実行する。

```powershell
git status
git branch backup-before-julia-rewrite
git switch backup-before-julia-rewrite
git switch main
```

古い追跡済みファイルを削除する:

```powershell
git rm -r .
```

その後、このZIPの中身を既存フォルダへコピーする。

確認:

```powershell
git status
```

コミットして上書き:

```powershell
git add .
git commit -m "Rewrite engine in Julia with bilingual Black Swan documentation"
git push origin main
```

## 方法B: ZIPのフォルダから強制的に差し替える

ZIPを展開したフォルダで:

```powershell
git init
git remote add origin https://github.com/YOUR_NAME/hoho-consciousness-engine.git
git fetch origin
git checkout -B main origin/main
git rm -r .
```

このリポジトリ一式を同じフォルダへ配置してから:

```powershell
git add .
git commit -m "Replace Python prototype with Julia HOHO consciousness engine"
git push origin main
```

## 注意

履歴を完全に消す必要はない。通常のコミットとして上書きすれば、古いPython版もGit履歴から確認できる。

`README.md`が日本語版、`README_EN.md`が英語版。
