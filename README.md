# gitops-lab

k8s / Helm / ArgoCD を手を動かしながら学ぶための学習リポジトリ。

## ロードマップ

- [x] Step 1: リポジトリ初期化 & kindクラスタ構築
- [x] Step 2: 素のマニフェストでサンプルアプリをデプロイ(kubectl操作の復習)
- [x] Step 3: Helmチャート化
- [x] Step 4: ArgoCDインストール
- [ ] Step 5: GitOps化(ArgoCD ApplicationがこのリポジトリのHelmチャートを自動同期)
- [ ] Step 6: 応用(環境分割 / App of Apps / sync policy)

## ディレクトリ構成(予定)

```
clusters/     kind クラスタ定義
apps/         Step2用の素のk8sマニフェスト
charts/       Step3以降のHelmチャート
argocd/       ArgoCDのインストール・Application定義
```

## 前提ツール

- Docker, kubectl, helm, kind (インストール済み)
