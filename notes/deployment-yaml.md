# deployment.yaml 一行ずつメモ

```yaml
1  apiVersion: apps/v1
2  kind: Deployment
3  metadata:
4    name: sample-app
5    namespace: sample-app
6    labels:
7      app: sample-app
8  spec:
9    replicas: 3
10   selector:
11     matchLabels:
12       app: sample-app
13   template:
14     metadata:
15       labels:
16         app: sample-app
17     spec:
18       containers:
19         - name: nginx
20           image: nginx:1.27-alpine
21           ports:
22             - containerPort: 80
23           volumeMounts:
24             - name: html
25               mountPath: /usr/share/nginx/html
26       volumes:
27         - name: html
28           configMap:
29             name: sample-app-html
```

## 行ごとの意味

- **1行目 `apiVersion: apps/v1`**: Deployment/ReplicaSet/StatefulSetなど「ワークロード管理系」は`apps`グループに属する。Namespace/ConfigMap/Serviceの`v1`(コアグループ、グループ名なし)とは別枠。
- **2行目 `kind: Deployment`**
- **3〜7行目 `metadata`(Deploymentオブジェクト自身)**
  - `name`/`namespace`は今までと同じ
  - **6〜7行目 `labels`はDeploymentという「オブジェクト自体」に貼るラベル**。`kubectl get deployment -l app=sample-app`のような検索用。Serviceのマッチングには無関係。
- **8行目 `spec:`** — Deploymentの望ましい状態の開始
- **9行目 `replicas: 3`** — 維持したいPod数
- **10〜12行目 `selector.matchLabels`** — ReplicaSetが管理対象とみなすPodの条件。**15〜16行目のPodラベルと完全一致必須**(不一致だとapply時にエラー)
- **13行目 `template:`** — Podのひな形の開始。DeploymentはPodを直接定義せず、ReplicaSetがこのテンプレート通りに複製する
- **14〜16行目 `template.metadata.labels`** — 実際に生成される**Podに貼られるラベル**。6〜7行目のDeployment自身のラベルとは別物。Service側のselectorとマッチする対象もこちら。
- **17行目 `spec:`** — Podのspec。8行目のDeploymentのspecとは階層が違う別物(同じキー名だがネスト先が異なる)
- **18〜20行目 `containers`** — `-`はYAMLのリスト記法。1Podに複数コンテナも可(サイドカーパターン)。`nginx:1.27-alpine`の`alpine`は軽量ベースイメージ。
- **21〜22行目 `ports.containerPort`** — **実際にポートを開ける設定ではない**。ドキュメント的情報のみ。プロセスは記述の有無に関わらずリッスンしている。
- **23〜25行目 `volumeMounts`** — 「`html`という名前のVolumeをコンテナ内の`/usr/share/nginx/html`にマウントする」指示。`name: html`はこのPod仕様内だけのローカルな識別子。
- **26〜29行目 `volumes`** — 「`html`という名前のVolumeは`sample-app-html`というConfigMapを使う」という材料の定義。`volumes`(材料の定義)と`volumeMounts`(使う場所の指示)が分離されており、`name`文字列が両者をつなぐ。

## この回で押さえた3つの新概念

1. APIグループの違い(`v1` vs `apps/v1`)
2. 2種類のlabels(Deployment自身のラベル vs Podに貼られるラベル)— 後者だけがselector/Serviceマッチング対象
3. volumes(材料の定義)とvolumeMounts(使う場所の指示)の分離。containerPortは実際のポート開放ではない。
