#!/bin/bash

APP_CONTAINER="sudoku-app"
INSTALL_DIR="/var/www/html"

echo "-------------------------"
echo "$APP_CONTAINER コンテナ内の Laravel をアンインストールすんで！"
echo "-------------------------"

if ! docker ps --format '{{.Names}}' | grep -q "^${APP_CONTAINER}$"; then
  echo "$APP_CONTAINER は起動してへんわ。コンテナを起動してんか。現在起動中のコンテナは: $(docker ps --format　'{{.Names}}' | tr '\n' ', ')"
  exit 1
fi

docker exec -it "$APP_CONTAINER" bash -c "
  echo 'Laravel プロジェクトを削除中・・・';
  rm -rf $INSTALL_DIR/*
  echo 'Laravel のアンインストールが完了したで。';
"

echo "-------------------------"
echo "$APP_CONTAINER コンテナ内の Laravel をアンインストール完了したで！"
echo "-------------------------"
