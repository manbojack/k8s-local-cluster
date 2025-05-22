#!/bin/bash
set -euo pipefail
echo "📝 Добавляем записи в /etc/hosts на хост-машине..."

CONTAINERS=("master" "node-0" "node-1")
TIMEOUT=10
SLEEP_INTERVAL=2

echo "# lxc-hosts-start" | sudo tee -a /etc/hosts

for c in "${CONTAINERS[@]}"; do
  echo "⏳ Ожидаем IP для контейнера $c..."

  IP=""
  elapsed=0
  while [[ -z "$IP" && $elapsed -lt $TIMEOUT ]]; do
    IP_RAW=$(lxc list "$c" -c 4 --format=csv)
    IP=$(echo "$IP_RAW" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n1 || true)
    if [[ -z "$IP" ]]; then
      sleep $SLEEP_INTERVAL
      ((elapsed+=SLEEP_INTERVAL))
    fi
  done

  if [[ -n "$IP" ]]; then
    echo "$IP $c" | sudo tee -a /etc/hosts
    echo "✅ IP для $c найден: $IP"
  else
    echo "❌ Не могу получить IP для $c за $TIMEOUT секунд" >&2
    exit 1
  fi
done

echo "# lxc-hosts-end" | sudo tee -a /etc/hosts

echo "✅ Записи успешно добавлены в /etc/hosts."
