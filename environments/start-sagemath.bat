@echo off
REM SageMath Jupyter環境をPodmanで起動するWindowsバッチスクリプト

echo SageMath Jupyter環境をPodmanで起動します...

REM 変数設定
set IMAGE_NAME=sagemath-jupyter
set CONTAINER_NAME=sagemath-jupyter
set HOST_PORT=8888
set CONTAINER_PORT=8888

REM 現在のディレクトリを取得
set SCRIPT_DIR=%~dp0
set PROJECT_ROOT=%SCRIPT_DIR%..

REM 必要なディレクトリを作成
if not exist "%PROJECT_ROOT%\notebooks" mkdir "%PROJECT_ROOT%\notebooks"
if not exist "%PROJECT_ROOT%\data" mkdir "%PROJECT_ROOT%\data"

REM イメージをビルド
echo Podmanイメージをビルド中...
podman build -t %IMAGE_NAME% -f "%SCRIPT_DIR%Containerfile" "%SCRIPT_DIR%"
if errorlevel 1 (
    echo エラー: イメージのビルドに失敗しました
    pause
    exit /b 1
)

REM 既存のコンテナを停止・削除
echo 既存のコンテナを確認中...
podman ps -a --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo 既存のコンテナを停止・削除中...
    podman stop %CONTAINER_NAME% 2>nul
    podman rm %CONTAINER_NAME% 2>nul
)

REM コンテナを起動
echo コンテナを起動中...
podman run -d ^
    --name %CONTAINER_NAME% ^
    -p %HOST_PORT%:%CONTAINER_PORT% ^
    -v "%PROJECT_ROOT%\notebooks:/home/sage/notebooks:Z" ^
    -v "%PROJECT_ROOT%\data:/home/sage/data:Z" ^
    -e JUPYTER_ENABLE_LAB=yes ^
    --user sage ^
    %IMAGE_NAME%

if errorlevel 1 (
    echo エラー: コンテナの起動に失敗しました
    pause
    exit /b 1
)

echo.
echo SageMath Jupyter環境が起動しました！
echo ブラウザで http://localhost:%HOST_PORT% にアクセスしてください
echo.
echo コンテナを停止するには:
echo   podman stop %CONTAINER_NAME%
echo.
echo コンテナを削除するには:
echo   podman rm %CONTAINER_NAME%
echo.
echo ログを確認するには:
echo   podman logs %CONTAINER_NAME%
echo.
pause