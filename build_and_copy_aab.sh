#!/bin/bash

echo "📦 AAB 빌드 시작..."
flutter clean
flutter pub get
flutter build appbundle --release

AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
BASE_DEST="/Users/sondong-wook/Downloads/앱개발_중요/daily_one_minute_app/aab"
TODAY=$(date +%Y-%m-%d)
DEST_FOLDER="$BASE_DEST/$TODAY/"

if [ ! -f "$AAB_PATH" ]; then
  echo "❌ AAB 빌드 실패 또는 파일을 찾을 수 없습니다!"
  exit 1
fi

mkdir -p "$DEST_FOLDER"

# 순차 폴더 생성: 1, 2, 3 ...
i=1
while [ -d "$DEST_FOLDER/$i" ]; do
  i=$((i + 1))
done

TARGET_DIR="$DEST_FOLDER/$i"
mkdir -p "$TARGET_DIR"

cp "$AAB_PATH" "$TARGET_DIR"

echo "✅ 빌드 완료 및 복사 성공!"
echo "📁 저장 위치: $TARGET_DIR"

