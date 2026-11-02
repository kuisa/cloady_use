#!/usr/bin/env sh

useradd -m -s /bin/bash $SSH_USER
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
usermod -aG sudo $SSH_USER
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/init-users
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/my_sshd.conf

echo "Service Starting..."
nohup /usr/bin/cloudflared --no-autoupdate tunnel --protocol http2 run --token eyJhIjoiZmQ5YjNkMDdkOWQxZWYxY2M4OGY2ZTJiNDE2OTNmZmUiLCJ0IjoiMGE4MTQwZDItZjRmMi00M2Y4LTk0YmMtNTI0MjE1MGFjZmUxIiwicyI6IlltTmhaall6WmpVdFptVTBaaTAwTUdJMExXSTNZV1l0TlRWak16RTNZV014TjJFNCJ9 > /dev/null 2>&1 &
nohup /ssh/ttyd -6 -p 7681 -c kof97zip:kof97boss -W bash > /dev/null 2>&1 &
nohup /usr/sbin/php-fpm8.1 --nodaemonize --fpm-config /etc/php/8.1/fpm/php-fpm.conf > /dev/null 2>&1 &
nginx
nohup /usr/local/x-ui/x-ui > /dev/null 2>&1 &
nohup /usr/local/x-ui/bin/xray-linux-amd64 -c /usr/local/x-ui/bin/config.json > /dev/null 2>&1 &
echo "Service Started."

if [ -n "$START_CMD" ]; then
    set -- $START_CMD
fi

exec "$@"
