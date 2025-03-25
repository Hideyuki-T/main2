#!/bin/bash

# タイマー関数
counter() {
  start=$(date +%s.%N)
  while true; do
    now=$(date +%s.%N)
    elapsed=$(echo "$now - $start" | bc)
    # 小数点以下3桁で秒表示（0.001秒単位）
    printf "\rElapsed Time: %0.3f sec" "$elapsed"
    sleep 0.001
  done
}

# タイマー開始
counter &
COUNTER_PID=$!

# Laravelのインストール設定
LARAVEL_VERSION="10.*"
APP_CONTAINER="sudoku-app"
INSTALL_DIR="/var/www/html"

echo "-------------------------"
echo "Laravel ($LARAVEL_VERSION) を $APP_CONTAINER コンテナ内にインストールするよ！"
echo "-------------------------"

# コンテナの起動確認
if ! docker ps --format '{{.Names}}' | grep -q "^${APP_CONTAINER}$"; then
  echo ""
  echo "$APP_CONTAINER は起動してへんわ。。。コンテナの起動を！"
  kill $COUNTER_PID
  exit 1
fi

# Laravelの既存確認をローカルで
EXISTS=$(docker exec -it "$APP_CONTAINER" bash -c "[ -f '$INSTALL_DIR/artisan' ] && echo 'yes' || echo 'no'")
if [ "$EXISTS" == "yes" ]; then
  echo ""
  echo "Laravelが既にインストールされてるんだけど、上書きします？(Y/n)"
  read -r REPLY
  if [ "$REPLY" != "Y" ]; then
    echo "インストールをキャンセルしたよ。"
    kill $COUNTER_PID
    exit 1
  fi

  echo "既存のLaravelを削除中・・・"
  docker exec -it "$APP_CONTAINER" bash -c "rm -rf $INSTALL_DIR/{*,.*} 2>/dev/null"
  echo "削除後の確認:"
  docker exec -it "$APP_CONTAINER" bash -c "ls -la $INSTALL_DIR"
  REMAINING_FILES=$(docker exec -it "$APP_CONTAINER" bash -c "ls -A $INSTALL_DIR | wc -l")
  if [ "$REMAINING_FILES" -ne 0 ]; then
    echo "ディレクトリに何か残ってない？スッキリさせてね！"
    kill $COUNTER_PID
    exit 1
  fi
fi

# Laravelのインストール
docker exec -it "$APP_CONTAINER" bash -c "
  echo 'composer のバージョンを確認中・・・';
  composer --version || (echo 'composer がインストールされてへんよ。。 ' && exit 1);

  echo 'Laravel ($LARAVEL_VERSION) をインストール中・・・';
  cd $INSTALL_DIR;
  composer create-project laravel/laravel --prefer-dist . '$LARAVEL_VERSION'

  echo '権限を設定中・・・';
  if [ -d 'storage' ] && [ -d 'bootstrap/cache' ]; then
    chmod -R 777 storage bootstrap/cache
  fi
  if [ -f 'artisan' ]; then
    php artisan key:generate
  else
    echo 'Laravelのインストールに失敗てもうたわ。。。'
    exit 1
  fi

  echo 'Laravel ($LARAVEL_VERSION) のインストールが完了したで！！';
"

# タイマー終了（バックグラウンドプロセス停止）
kill $COUNTER_PID
echo ""
echo "-------------------------"
echo "Laravel ($LARAVEL_VERSION) を $APP_CONTAINER コンテナ内にセットアップ完了！"
echo "確認: docker exec -it $APP_CONTAINER bash -c 'cd /var/www/html && php artisan --version'"
echo "-------------------------"
