#!/bin/bash
# check_communication.sh
# 各コンテナ間の通信確認スクリプト

APP="sudoku-app"
NGINX="sudoku-nginx"
DB="sudoku-db"

# --- sudoku-nginx -> sudoku-app の接続テスト ---
echo "【テスト1】$NGINX から $APP のポート9000への接続確認"
docker exec $NGINX sh -c "nc -zv $APP 9000"
if [ $? -eq 0 ]; then
    echo "成功: $NGINX は $APP のポート9000に接続できます。"
else
    echo "失敗: $NGINX は $APP のポート9000に接続できません。"
fi
echo "-------------------------------------"

# --- sudoku-app -> sudoku-db の接続テスト ---
echo "【テスト2】$APP から $DB のポート5432への接続確認"
docker exec $APP sh -c "nc -zv $DB 5432"
if [ $? -eq 0 ]; then
    echo "成功: $APP は $DB のポート5432に接続できます。"
else
    echo "失敗: $APP は $DB のポート5432に接続できません。"
fi
echo "-------------------------------------"

echo "通信テストを完了しました。"
