#!/bin/bash

# ログファイルを保存するディレクトリとファイル名を設定
LOG_DIR="./"
mkdir -p "$LOG_DIR"

# テーブルヘッダーを設定
printf "%-15s %-25s %-25s %-10s %-10s %-10s\n" "Label" "StartTime" "EndTime" "Duration(s)" "429 Errors" "400 Errors"

# 全体の開始時間
start_time=$(date +%s)

# リクエストを並列で実行
for i in {1..10}; do
  (
    req_success=false
    error_429_count=0
    error_400_count=0

    # 各リクエストの開始時間
    req_start_time=$(date +%s)

    while [ "$req_success" = false ]; do
      # APIリクエストの実行
      response=$(curl --write-out "%{http_code}" --silent --output /dev/null \
           --request POST \
           --url https://api.linode.com/v4/linode/instances \
           --header 'accept: application/json' \
           --header 'authorization: Bearer 3f03adb82c57fdda93ed63891961026e6acf0e24959ca67ce0bd2be6c5d9fc73' \
           --header 'content-type: application/json' \
           --data "
      {
        \"booted\": true,
        \"interfaces\": [
          {
            \"primary\": true,
            \"purpose\": \"public\"
          }
        ],
        \"swap_size\": 512,
        \"type\": \"g6-nanode-1\",
        \"region\": \"jp-osa\",
        \"image\": \"linode/ubuntu24.04\",
        \"root_pass\": \"cGWNJ&g6pTshdGA!N#3Fsz5THpczYg\$Drv\",
        \"tags\": [
          \"test\"
        ],
        \"label\": \"linode$i\"
      }")

      # ステータスコードを確認
      if [ "$response" -eq 200 ]; then
        req_success=true
      elif [ "$response" -eq 429 ]; then
        # 429の場合、リトライを即座に実行
        error_429_count=$((error_429_count + 1))
      elif [ "$response" -eq 400 ]; then
        # 400エラーをカウントし、リトライを即座に実行
        error_400_count=$((error_400_count + 1))
      else
        echo "Error: Unexpected response code $response for request $i" | tee -a "$LOG_DIR/request-$i.log"
        break
      fi
    done

    # 各リクエストの終了時間
    req_end_time=$(date +%s)
    req_duration=$((req_end_time - req_start_time))

    # 時刻をフォーマットして表示
    req_start_time_formatted=$(date -r "$req_start_time" +"%Y-%m-%d %H:%M:%S")
    req_end_time_formatted=$(date -r "$req_end_time" +"%Y-%m-%d %H:%M:%S")

    # 結果を表に出力 (yyyy-mm-dd hh:mm:ss形式)
    printf "%-15s %-25s %-25s %-10s %-10s %-10s\n" "linode-$i" "$req_start_time_formatted" "$req_end_time_formatted" "$req_duration" "$error_429_count" "$error_400_count"

  ) &
done

# 全ての並列プロセスが終了するまで待つ
wait

# 全体の終了時間
end_time=$(date +%s)
total_duration=$((end_time - start_time))

echo "All requests finished in ${total_duration}s"
