#!/bin/bash
# User data script for EC2 instance initialization

# Логування
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting user data script execution at $(date)"

# Оновлення системи
apt-get update -y
apt-get upgrade -y

# Встановлення необхідних пакетів
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    wget \
    unzip \
    awscli \
    htop \
    tree \
    jq

# Створення користувача для додатка (якщо потрібно)
if ! id "webapp" &>/dev/null; then
    useradd -m -s /bin/bash webapp
    usermod -aG sudo webapp
fi

# Додавання ubuntu користувача до sudo групи
usermod -aG sudo ubuntu

# Налаштування SSH
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh

# Створення директорій для логів
mkdir -p /var/log/webapp
chown webapp:webapp /var/log/webapp

# Налаштування CloudWatch агента (опціонально)
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
# dpkg -i -E ./amazon-cloudwatch-agent.deb

# Створення базового health check файлу
mkdir -p /var/www/html
echo "healthy" > /var/www/html/health
chown -R www-data:www-data /var/www/html

# Налаштування файрвола (UFW)
ufw --force enable
ufw allow ssh
ufw allow http
ufw allow https

# Створення swap файлу для t2.micro інстансів
if [ ! -f /swapfile ]; then
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
fi

# Налаштування часового поясу
timedatectl set-timezone UTC

# Очищення
apt-get autoremove -y
apt-get autoclean

# Сигнал що ініціалізація завершена
echo "User data script completed successfully at $(date)"
touch /var/log/user-data-completed

# shutdown -r +1