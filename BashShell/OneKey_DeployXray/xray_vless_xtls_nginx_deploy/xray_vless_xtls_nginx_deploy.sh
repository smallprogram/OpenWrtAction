#!/bin/bash
# OP编译

# Copyright (c) 2019-2022 smallprogram
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File: xray_vless_xtls_nginx_deploy.sh
# Description: xray vless xtls nginx deploy

echo -e "\033[31m 请输入你的域名，请一定确保这个域名A记录已经映射到你的服务器 \033[0m"

read domainName

cd



echo -e "\033[31m 开始更新系统 \033[0m"
sleep 5s
apt-get -y update 
apt-get -y install socat
echo -e "\033[31m 系统更新完毕 \033[0m"
sleep 5s

echo -e "\033[31m 开始编译安装Nginx \033[0m"
sleep 5s
wget -nc --no-check-certificate https://www.openssl.org/source/openssl-1.1.1q.tar.gz -P /usr/local/src
tar -zxvf  /usr/local/src/openssl-1.1.1q.tar.gz  -C /usr/local/src
wget -nc --no-check-certificate http://nginx.org/download/nginx-1.23.1.tar.gz -P /usr/local/src
tar -zxvf /usr/local/src/nginx-1.23.1.tar.gz -C /usr/local/src
apt  -y install build-essential libpcre3 libpcre3-dev zlib1g-dev git  dbus manpages-dev aptitude g++
mkdir -p /etc/nginx
cd /usr/local/src/nginx-1.23.1

./configure --prefix=/etc/nginx \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-pcre \
        --with-http_realip_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_secure_link_module \
        --with-http_v2_module \
        --with-cc-opt='-O3' \
        --with-openssl=../openssl-1.1.1q

make && make install

rm -rf /usr/local/src/nginx-1.23.1
rm -rf /usr/local/src/nginx-1.23.1.tar.gz 
rm -rf /usr/local/src/openssl-1.1.1q
rm -rf /usr/local/src/openssl-1.1.1q.tar.gz

echo -e "\033[31m Nginx编译安装完毕 \033[0m"
sleep 5s

cp /etc/nginx/conf/nginx.conf -d /etc/nginx/conf/nginx.conf.default.bak.$(date +"%Y.%m.%d-%H%M")
echo -e "\033[31m 备份Nginx默认配置完毕 \033[0m"
sleep 5s


echo -e "\033[31m 开始创建Nginx服务，并开启Nginx \033[0m"
sleep 5s
cat >/etc/systemd/system/nginx.service <<EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
PIDFile=/etc/nginx/logs/nginx.pid
ExecStartPre=/etc/nginx/sbin/nginx -t
ExecStart=/etc/nginx/sbin/nginx -c /etc/nginx/conf/nginx.conf
ExecReload=/etc/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nginx
systemctl restart nginx
echo -e "\033[31m 开启Nginx完毕 \033[0m"
sleep 5s

echo -e "\033[31m 开始申请ECC证书 \033[0m"
sleep 5s
cd
curl https://get.acme.sh | sh -s email=abc@abc.com

alias acme.sh=~/.acme.sh/acme.sh

/root/.acme.sh/acme.sh --issue -w /etc/nginx/html -d $domainName --keylength ec-256

echo -e "\033[31m 申请ECC证书完成 \033[0m"
sleep 5s

echo -e "\033[31m 开始安装ECC证书 \033[0m"
sleep 5s
mkdir -p /data
mkdir -p /data/$domainName

/root/.acme.sh/acme.sh --installcert -d $domainName --fullchainpath /data/$domainName/fullchain.crt --keypath /data/$domainName/$domainName.key --ecc --force
echo -e "\033[31m 安装ECC证书完成 \033[0m"
sleep 5s


echo -e "\033[31m 开始配置Nginx \033[0m"
sleep 5s
mkdir -p /usr/wwwroot
wget -P /usr/wwwroot https://github.com/smallprogram/OpenWrtAction/raw/main/source/web.zip
unzip -o /usr/wwwroot/web.zip -d /usr/wwwroot

cp /etc/nginx/conf/nginx.conf -d /etc/nginx/conf/nginx.conf.bak.$(date +"%Y.%m.%d-%H%M")

cat > /etc/nginx/conf/nginx.conf <<EOF
user  root;
worker_processes  3;

events {
    worker_connections  4096;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for" '
                      '$proxy_protocol_addr:$proxy_protocol_port';

    access_log  logs/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
   
    server {
        listen       unix:/dev/shm/default.sock proxy_protocol;
        listen       unix:/dev/shm/h2c.sock http2 proxy_protocol;
        server_name  _;
        root         /usr/wwwroot;

        set_real_ip_from 127.0.0.1;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
    
    include conf.d/*.conf;
}
EOF

systemctl daemon-reload
systemctl restart nginx

echo -e "\033[31m 配置Nginx完成 \033[0m"
sleep 5s

echo -e "\033[31m 开始安装并配置xray \033[0m"
sleep 5s
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root --beta


cat >/usr/local/etc/xray/config.json <<EOF
{
  "log": {
    "error": "/usr/local/etc/xray/error.log",
    "loglevel": "warning",
    "dnsLog": false
  },
  "inbounds": [
    {
      "tag": "vlessUser",
      "port": 4430,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "faed07bb-7362-4103-80d1-28efa9373e53",
            "flow": "xtls-rprx-direct",
            "level": 0,
            "email": "home"
          },
          {
            "id": "98dbc57b-8a06-4ff9-a306-8a447360c156",
            "flow": "xtls-rprx-direct",
            "level": 0,
            "email": "cgyy"
          },
          {
            "id": "53523f6f-231b-45ff-a225-8bbd649876aa",
            "flow": "xtls-rprx-direct",
            "level": 0,
            "email": "temp"
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": "/dev/shm/default.sock",
            "xver": 1
          },
          {
            "alpn": "h2",
            "dest": "/dev/shm/h2c.sock",
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "alpn": [
            "h2",
            "http/1.1"
          ],
          "certificates": [
            {
              "certificateFile": "/data/$domainName/fullchain.crt",
              "keyFile": "/data/$domainName/$domainName.key"
            }
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

service xray restart
echo -e "\033[31m 配置完成，请访问 https://$domainName:4430 \033[0m"
