# 🚀 Запуск LXC

![LXC](https://img.shields.io/badge/LXC-5.21.3-blue?logo=lxc)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-E95420?logo=ubuntu)
![Bash](https://img.shields.io/badge/Bash-scripting-4EAA25?logo=gnubash)

---

## 🧰 Что имеем:

- 🧠 **CPU:** 8 ядер  
- 🧵 **Memory:** 8GB  
- 📦 **LXC (client/server):** 5.21.3 LTS  
- ⚙️ **Ansible:** 2.10.8

---

### Контейнеры LXC:
- `master`
- `node-0`
- `node-1`

---

## 📋 Запуск
```bash
./start.sh
```

## 📋 Удаление
```bash
./destroy.sh
```

---

## 📂 Структура проекта

```
lxc-local/
├── destroy.sh
├── README.md
├── scripts
│   ├── 01-create-containers.sh
│   ├── 02-update-hosts.sh
│   ├── 03-setup-ssh.sh
└── start.sh

```

---

## 📝 Примечания

- Все имена контейнеров используются как DNS-имена (через `/etc/hosts`).

---

## 🧠 Полезные ссылки

- 📦 [Официальный сайт LXC](https://linuxcontainers.org/)

---
