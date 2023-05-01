#!/usr/bin/env bash

# 定义 UUID 及伪装路径、哪吒面板参数，请自行修改. (注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID='6a4ff628-8825-4fef-bc59-8eb99714dd11'
VMESS_WSPATH='/vm'
VLESS_WSPATH='/vl'
TROJAN_WSPATH='/tr'
SS_WSPATH='/ss'

sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" config.json
sed -i "s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" /etc/nginx/nginx.conf
sed -i "s#RELEASE_RANDOMNESS#${RELEASE_RANDOMNESS}#g" /etc/supervisor/conf.d/supervisord.conf

# 设置 nginx 伪装站
rm -rf /usr/share/nginx/*
wget https://gitlab.com/Misaka-blog/xray-paas/-/raw/main/mikutap.zip -O /usr/share/nginx/mikutap.zip
unzip -o "/usr/share/nginx/mikutap.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/mikutap.zip

# 伪装 xray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv xray ${RELEASE_RANDOMNESS}
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
cat config.json | base64 > config
rm -f config.json

curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent data.dapao.live 443 VOcEKXFBoC5kQFZsU6 --tls


nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} -config=config.json
