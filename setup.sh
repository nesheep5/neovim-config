#!/usr/bin/env bash
# Neovim 設定のセットアップスクリプト。
# ~/.config/nvim をこのリポジトリの nvim/ への symlink にする。
# リポジトリの clone 先に依存しない（スクリプト自身の位置を基準にする）。
set -euo pipefail

# このスクリプトが置かれているディレクトリ（= リポジトリルート）
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${REPO_DIR}/nvim"
TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# symlink 元が存在するか確認
if [ ! -d "$SOURCE" ]; then
  echo "エラー: 設定ディレクトリが見つかりません: $SOURCE" >&2
  exit 1
fi

# target の親ディレクトリ（~/.config）を用意
mkdir -p "$(dirname "$TARGET")"

# 既存の target を処理
if [ -L "$TARGET" ]; then
  # すでに symlink の場合
  current="$(readlink "$TARGET")"
  if [ "$current" = "$SOURCE" ]; then
    echo "既に正しい symlink が張られています: $TARGET -> $SOURCE"
    exit 0
  fi
  echo "既存の symlink を張り替えます: $TARGET ($current -> $SOURCE)"
  ln -sfn "$SOURCE" "$TARGET"
elif [ -e "$TARGET" ]; then
  # 実体（ディレクトリ/ファイル）がある場合はバックアップして退避
  backup="${TARGET}.bak.$(date +%Y%m%d%H%M%S)"
  echo "既存の $TARGET を $backup に退避します"
  mv "$TARGET" "$backup"
  ln -sfn "$SOURCE" "$TARGET"
else
  # 何もない場合は素直に作成
  ln -sfn "$SOURCE" "$TARGET"
fi

echo "完了: $TARGET -> $SOURCE"
