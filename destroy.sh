#!/bin/bash
set -e

CONTAINERS=("master" "node-0" "node-1")
SSH_CONFIG_DIR="$HOME/.ssh/config.d"

echo "🧨 Удаляем LXC контейнеры и блок в /etc/hosts..."

for name in "${CONTAINERS[@]}"; do
    echo "▶️ Обработка контейнера: $name"

    if lxc info "$name" &>/dev/null; then
        echo "⏹ Останавливаю $name..."
        lxc stop "$name" || true

        echo "❌ Удаляю $name..."
        lxc delete "$name"
        echo "✅ Контейнер $name удалён."
    else
        echo "⚠️ Контейнер $name не найден — пропущен."
    fi

    # Удаление ssh-конфига
    CONF_PATH="$SSH_CONFIG_DIR/$name.conf"
    if [ -f "$CONF_PATH" ]; then
        rm -f "$CONF_PATH"
        echo "🗑 Удалён SSH конфиг: $CONF_PATH"
    fi
done

# Удаляем блок из /etc/hosts
echo "🧹 Удаляем блок из /etc/hosts..."

sudo cp /etc/hosts /etc/hosts.bak
sudo sed -i '/# k8s-lxc-hosts-start/,/# k8s-lxc-hosts-end/d' /etc/hosts

echo "✅ Блок удалён. Бэкап сохранён: /etc/hosts.bak"
echo "🏁 Готово."
