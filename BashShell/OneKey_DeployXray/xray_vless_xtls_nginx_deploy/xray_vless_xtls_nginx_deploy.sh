#!/bin/bash


acmeEmail
domainName
timer=15

# acme
function acmeinit(){
    apt-get -y install socat
    echo -e "\033[31m 请输入用于注册acme的Email，注意不要输入无效的Email，否则将无法获取证书！"
    read acmeEmail

}













# 安装acme依赖
apt-get update 
















cat config.json | jq '.inbounds[0].settings.clients += [{"id":"12312","flow":"ddd",level:0,"email":"ccc"}]' >> test.json


jq '.inbounds[0].streamSettings.xtlsSettings.certificates[0].certificateFile="dfasdfasdf"' config.json > test.json

