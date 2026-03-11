#!/bin/bash
# LibreCrawl i18n - 翻訳ファイルの更新スクリプト
# 使い方:
#   ./update-translations.sh          # 抽出 → 既存の .po を更新 → コンパイル
#   ./update-translations.sh init     # 新規言語を追加する場合 (例: pybabel init -i messages.pot -d translations -l de)

set -e
cd "$(dirname "$0")"

echo "Extracting strings..."
pybabel extract -F babel.cfg -o messages.pot .

if [ "$1" = "init" ]; then
    LANG=${2:-ja}
    echo "Initializing $LANG translation..."
    pybabel init -i messages.pot -d translations -l "$LANG"
    echo "Edit translations/$LANG/LC_MESSAGES/messages.po and add translations, then run this script again."
else
    echo "Updating existing translations..."
    pybabel update -i messages.pot -d translations

    echo "Compiling..."
    pybabel compile -d translations

    echo "Done! Restart the app to see changes."
fi
