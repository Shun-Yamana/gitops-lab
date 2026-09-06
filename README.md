# gitops-lab

k8s / Helm / ArgoCD を手を動かしながら学ぶための学習リポジトリ。

## ロードマップ

- [x] Step 1: リポジトリ初期化 & kindクラスタ構築
- [x] Step 2: 素のマニフェストでサンプルアプリをデプロイ(kubectl操作の復習)
- [x] Step 3: Helmチャート化
- [x] Step 4: ArgoCDインストール
- [x] Step 5: GitOps化(ArgoCD ApplicationがこのリポジトリのHelmチャートを自動同期)
- [x] Step 6: 応用(環境分割 / sync policy)

## ディレクトリ構成

```
clusters/            kind クラスタ定義
apps/                Step2用の素のk8sマニフェスト
charts/sample-app/   Helmチャート(values.yaml / values-dev.yaml / values-prod.yaml)
argocd/              ArgoCD本体のインストール定義とApplication定義
argocd/applications/ ArgoCD Application(sample-app / sample-app-dev / sample-app-prod)
notes/               学習の過程で作った復習ノート
```

## 前提ツール

- Docker, kubectl, helm, kind (インストール済み)

## クラスタの再現手順(ゼロから復元する場合)

```bash
kind create cluster --config clusters/kind-config.yaml
kubectl apply -f argocd/namespace.yaml
kubectl apply -n argocd -f argocd/install.yaml --server-side
kubectl get pods -n argocd   # 全部Runningになるまで待つ
kubectl apply -f argocd/applications/
```

**注意**: `argocd/install.yaml`は`--server-side`を付けずに`kubectl apply`すると、
CRD(`applicationsets.argoproj.io`)が巨大すぎて`kubectl.kubernetes.io/last-applied-configuration`
annotationの上限(256KiB)を超え、`Too long`エラーになる。必ず`--server-side`を付けること。

ArgoCDのUIへは以下でアクセスする。

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

ユーザー名`admin`、パスワードは以下で取得する。

```powershell
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String((kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}")))
```
