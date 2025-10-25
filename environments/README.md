# SageMath Jupyter Podman環境

このディレクトリには、SageMath JupyterをPodmanで実行するための環境設定ファイルが含まれています。

## ファイル構成

- `Containerfile`: SageMath Jupyterコンテナのビルド設定
- `docker-compose.yml`: Docker Composeを使用する場合の設定（Podmanでも使用可能）
- `start-sagemath.sh`: Linux/Mac用の起動スクリプト
- `start-sagemath.bat`: Windows用の起動スクリプト
- `stop-sagemath.sh`: Linux/Mac用の停止スクリプト
- `stop-sagemath.bat`: Windows用の停止スクリプト

## 使用方法

### 前提条件

- Podmanがインストールされていること
- インターネット接続があること（初回ビルド時）

### 起動方法

#### Windows
```cmd
start-sagemath.bat
```

#### Linux/Mac
```bash
chmod +x start-sagemath.sh
./start-sagemath.sh
```

### アクセス方法

起動後、ブラウザで以下のURLにアクセス:
```
http://localhost:8888
```

### 停止方法

#### Windows
```cmd
stop-sagemath.bat
```

#### Linux/Mac
```bash
chmod +x stop-sagemath.sh
./stop-sagemath.sh
```

## ディレクトリ構成

起動後、プロジェクトルートに以下のディレクトリが自動作成されます：

- `../notebooks/`: Jupyterノートブックファイルが保存される
- `../data/`: データファイル用ディレクトリ

これらのディレクトリはホストマシンとコンテナ間で共有されるため、コンテナを削除してもファイルは保持されます。

## 手動でPodmanコマンドを実行する場合

### イメージビルド
```bash
podman build -t sagemath-jupyter -f Containerfile .
```

### コンテナ起動
```bash
podman run -d \
    --name sagemath-jupyter \
    -p 8888:8888 \
    -v ../notebooks:/home/sage/notebooks:Z \
    -v ../data:/home/sage/data:Z \
    -e JUPYTER_ENABLE_LAB=yes \
    --user sage \
    sagemath-jupyter
```

### コンテナ停止・削除
```bash
podman stop sagemath-jupyter
podman rm sagemath-jupyter
```

## トラブルシューティング

### ポートが既に使用されている場合
`start-sagemath.sh`または`start-sagemath.bat`内の`HOST_PORT`変数を別のポート番号に変更してください。

### コンテナが起動しない場合
```bash
podman logs sagemath-jupyter
```
でログを確認してください。

### SELinuxが有効な環境の場合
ボリュームマウント時に`:Z`オプションが使用されているため、SELinux環境でも動作するはずです。問題がある場合は、SELinuxを一時的に無効にするか、適切なコンテキストを設定してください。