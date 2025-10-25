#!/bin/bash

# SageMath Jupyter環境をPodmanで起動するスクリプト

set -e

# 変数設定
IMAGE_NAME="sagemath-jupyter"
CONTAINER_NAME="sagemath-jupyter"
HOST_PORT="8888"
CONTAINER_PORT="8888"

# 現在のディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 必要なディレクトリを作成
mkdir -p "$PROJECT_ROOT/notebooks"
mkdir -p "$PROJECT_ROOT/data"

echo "SageMath Jupyter環境をPodmanで起動します..."

# イメージをビルド
echo "Podmanイメージをビルド中..."
podman build -t $IMAGE_NAME -f "$SCRIPT_DIR/Containerfile" "$SCRIPT_DIR"

# 既存のコンテナを停止・削除
echo "既存のコンテナを確認中..."
if podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "既存のコンテナを停止・削除中..."
    podman stop $CONTAINER_NAME || true
    podman rm $CONTAINER_NAME || true
fi

# コンテナを起動
echo "コンテナを起動中..."
podman run -d \
    --name $CONTAINER_NAME \
    -p $HOST_PORT:$CONTAINER_PORT \
    -v "$PROJECT_ROOT/notebooks:/home/sage/notebooks:Z" \
    -v "$PROJECT_ROOT/data:/home/sage/data:Z" \
    -e JUPYTER_ENABLE_LAB=yes \
    --user sage \
    $IMAGE_NAME

echo "SageMath Jupyter環境が起動しました！"
echo "ブラウザで http://localhost:$HOST_PORT にアクセスしてください"
echo ""
echo "コンテナを停止するには:"
echo "  podman stop $CONTAINER_NAME"
echo ""
echo "コンテナを削除するには:"
echo "  podman rm $CONTAINER_NAME"
echo ""
echo "ログを確認するには:"
echo "  podman logs $CONTAINER_NAME"