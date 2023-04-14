#!/bin/bash

# Copyright (c) 2019-2023 smallprogram
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/smallprogram/OpenWrtAction
# File: xray_vision_uTLS_REALITY_deploy.sh
# Description: xray vision utls reality one key deploy



echo -e "\033[31m 开始安装并配置xray \033[0m"
sleep 5s
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root --beta

echo -e "\033[31m 开始生成随机UUID \033[0m"
sleep 5s

uuid=$(xray uuid)
xray x25519 > keys.txt
privateKey=$(cat keys.txt | sed -n '1p' | awk '{print $3}')
publicKey=$(cat keys.txt | sed -n '2p' | awk '{print $3}')
rm -rf keys.txt


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
			"port": 443,
			"protocol": "vless",
			"settings": {
				"clients": [
					{
						"id": "$uuid",
						"flow": "xtls-rprx-vision",
						"level": 0,
						"email": ""
					}
				],
				"decryption": "none"
			},
			"streamSettings": {
				"network": "tcp",
				"security": "reality",
				"realitySettings": {
					"show": false, 
					"dest": "www.microsoft.com:443",
					"xver": 0, 
					"serverNames": [ 
						"www.microsoft.com"
					],
					"privateKey": "$privateKey", // 必填，执行 ./xray x25519 生成
					"minClientVer": "1.8.0", // 选填，客户端 Xray 最低版本，格式为 x.y.z
					// "maxClientVer": "", // 选填，客户端 Xray 最高版本，格式为 x.y.z
					// "maxTimeDiff": 0, // 选填，允许的最大时间差，单位为毫秒
					"shortIds": [ // 必填，客户端可用的 shortId 列表，可用于区分不同的客户端
						 "" // 0 到 f，长度为 2 的倍数，长度上限为 16
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





echo -e "\033[31m Xray vision utls reality 配置完毕，具体内容如下： \033[0m"
echo -e "\033[34m 地址：你服务器的IP或者域名 \033[0m"
echo -e "\033[34m 端口：443 \033[0m"
echo -e "\033[34m ID: $uuid \033[0m"
echo -e "\033[34m 传输协议: TCP \033[0m"
echo -e "\033[34m 安全: TLS，REALITY \033[0m"
echo -e "\033[34m 域名: www.microsoft.com \033[0m"
echo -e "\033[34m 公钥: $publicKey \033[0m"
echo -e "\033[34m Short Id: 不填写 \033[0m"
echo -e "\033[34m   \033[0m"


echo -e "\033[31m 配置完成 \033[0m"
