#!/bin/bash
set -euo pipefail
echo "🚀 Запуск создания LXC контейнеров..."

CONTAINERS=("master" "node-0" "node-1")
IMAGE="ubuntu:20.04"

for c in "${CONTAINERS[@]}"; do
  if lxc list "$c" --format=json | grep -q "$c"; then
    echo "⚠️ Контейнер $c уже существует, пропускаем..."
  else
    echo "✨ Создаем контейнер $c на базе $IMAGE..."
    lxc launch "$IMAGE" "$c"
  fi
done

echo "✅ Контейнеры созданы."
