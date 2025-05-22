#!/bin/bash
set -euo pipefail
echo "▶️ Запускаем скрипты подготовки LXC и SSH..."

for script in scripts/0*.sh; do
  echo "🔹 Выполняем $script"
  bash "$script"
done

echo "🎉 Все скрипты выполнены."
