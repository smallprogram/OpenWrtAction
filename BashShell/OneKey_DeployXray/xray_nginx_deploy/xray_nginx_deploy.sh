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
# ！！！！！！！！！！！该脚本已弃用！！！！！！！！！！！！！！！！！！！！！！

webSite=web01.zip

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
wget -P /usr/wwwroot https://github.com/smallprogram/OpenWrtAction/raw/main/source/WebSite/$webSite
apt-get -y install unzip
unzip -o /usr/wwwroot/$webSite -d /usr/wwwroot

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

    server {
        listen       80;
        server_name  localhost;
	      root         /usr/wwwroot;

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
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

echo -e "\033[31m 开始生成随机UUID \033[0m"
sleep 5s

uuid=$(xray uuid)


cat >/usr/local/etc/xray/config.json <<EOF
{
    "log": {
        "error": "/usr/local/etc/xray/error.log",
        "loglevel": "warning",
        "dnsLog": false
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": 44300,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "flow": "xtls-rprx-vision",
                        "level": 0,
                        "email": "Custom"
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
                "security": "tls",
                "tlsSettings": {
                    "rejectUnknownSni": true,
                    "minVersion": "1.2",
                    "certificates": [
                        {
                            "ocspStapling": 3600,
                            "certificateFile": "/data/$domainName/fullchain.crt",
                            "keyFile": "/data/$domainName/$domainName.key"
                        }
                    ]
                }
            },
            "sniffing": {
                "enabled": true,
                "destOverride": [
                    "http",
                    "tls"
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ],
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:cn"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "policy": {
        "levels": {
            "0": {
                "handshake": 5, // 连接建立时的握手时间限制，单位为秒，默认值为 4，建议与默认值不同
                "connIdle": 360 // 连接空闲的时间限制，单位为秒，默认值为 300，建议与默认值不同
            }
        }
    }
}
EOF

service xray restart

echo -e "\033[31m 安装BBR加速 \033[0m"
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
echo -e "\033[31m 验证BBR \033[0m"
uname -r
# 查看内核版本，显示为最新版就表示 OK 了
sysctl net.ipv4.tcp_available_congestion_control
# net.ipv4.tcp_available_congestion_control = reno cubic bbr
sysctl net.ipv4.tcp_congestion_control
# net.ipv4.tcp_congestion_control = bbr
sysctl net.core.default_qdisc
# net.core.default_qdisc = fq
lsmod | grep bbr
# 返回值有 tcp_bbr 模块即说明 bbr 已启动。注意：并不是所有的 VPS 都会有此返回值，若没有也属正常。


# 配置自动更新证书
acme.sh --upgrade --auto-upgrade
acme.sh --renew -d $domainName --force --ecc
systemctl stop nginx && service xray stop
rm -rf /dev/shm/default.sock && rm -rf /dev/shm/h2c.sock
systemctl start nginx && service xray start
# xray会自动检测证书更新状态并重载，这里不用配置xray的证书检测了


echo -e "\033[31m Xray Vless+TCP+Version配置完毕，具体内容如下： \033[0m"
echo -e "\033[34m 地址：$domainName \033[0m"
echo -e "\033[34m 端口：44300 \033[0m"
echo -e "\033[34m 协议：Vless \033[0m"
echo -e "\033[34m ID: $uuid \033[0m"
echo -e "\033[34m 传输协议: TCP \033[0m"
echo -e "\033[34m 流控: xtls-rprx-vision \033[0m"
echo -e "\033[34m   \033[0m"


echo -e "\033[31m 配置完成，请访问 https://$domainName 查看网站效果 \033[0m"
