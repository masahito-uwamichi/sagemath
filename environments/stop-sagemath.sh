#!/bin/bash

# SageMath Jupyter環境を停止するスクリプト

set -e

CONTAINER_NAME="sagemath-jupyter"

echo "SageMath Jupyter環境を停止します..."

# コンテナが実行中かチェック
if podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "コンテナを停止中..."
    podman stop $CONTAINER_NAME
    echo "コンテナを削除中..."
    podman rm $CONTAINER_NAME
    echo "SageMath Jupyter環境が停止されました。"
else
    echo "コンテナ '$CONTAINER_NAME' は実行されていません。"
fi