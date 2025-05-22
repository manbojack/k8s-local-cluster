#!/bin/bash
set -euo pipefail
echo "🔐 Настраиваем SSH доступ к LXC контейнерам..."

CONTAINERS=("master" "node-0" "node-1")
SSH_CONFIG_DIR="$HOME/.ssh/config.d"
mkdir -p "$SSH_CONFIG_DIR"

for c in "${CONTAINERS[@]}"; do
  echo "➡️ Настройка SSH для $c..."

  PUBKEY=$(<~/.ssh/id_rsa.pub)

  # Настройка authorized_keys для root
  lxc exec "$c" -- bash -c "mkdir -p /root/.ssh && echo '$PUBKEY' > /root/.ssh/authorized_keys && chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys"

  # Разрешаем RootLogin
  lxc exec "$c" -- sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
  lxc exec "$c" -- systemctl restart ssh

  # Проверка ssh-доступа
  echo "⏳ Проверка ssh подключения к $c..."
  if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "root@$c" "w"; then
    echo "✅ SSH успешно подключился к $c"
  else
    echo "❌ Ошибка SSH подключения к $c"
  fi

  # Создаём ssh config entry
  CONFIG_PATH="$SSH_CONFIG_DIR/${c}.conf"
  cat > "$CONFIG_PATH" <<EOF
Host $c
  HostName $c
  User root
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
EOF

  echo "🛠 Конфиг для $c создан в $CONFIG_PATH"
done

echo "📎 Подключи конфиги из ~/.ssh/config.d/ добавив в ~/.ssh/config:"
echo "  Include config.d/*"
