@echo off
REM SageMath Jupyter環境を停止するWindowsバッチスクリプト

set CONTAINER_NAME=sagemath-jupyter

echo SageMath Jupyter環境を停止します...

REM コンテナが実行中かチェック
podman ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo コンテナを停止中...
    podman stop %CONTAINER_NAME%
    echo コンテナを削除中...
    podman rm %CONTAINER_NAME%
    echo SageMath Jupyter環境が停止されました。
) else (
    echo コンテナ '%CONTAINER_NAME%' は実行されていません。
)

pause