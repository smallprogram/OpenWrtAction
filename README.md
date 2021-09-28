
![image](https://img.shields.io/badge/support-x86%7CR4S-blue?style=flat&logo=rss)  ![image](https://img.shields.io/badge/SourceCode-Lean-green?style=flat&logo=GitHub) ![image](https://img.shields.io/badge/UpdateCheck-OneHour-blueviolet?style=flat&logo=Checkmarx) ![image](https://img.shields.io/badge/GithubAction-2Actions-important?style=flat&logo=GitHubActions)

# Lean Openwrt GitHubAction

![image](source/login.gif)
### 目前包含x86与R4S固件,根据源码更新自动编译


## 包含内容

#### 包含各种常用插件，特殊的内容如下：


|名称|类型|简介|源码地址
-|-|-|-
|SSRP|插件|Lean源码的亲儿子，评测说效率最高|https://github.com/fw876/helloworld|
|PassWall|插件|一款功能强大的科学工具|https://github.com/xiaorouji/openwrt-passwall|
|DockerMan|插件|OP上玩Docker的必备插件|https://github.com/lisaac/luci-app-dockerman|
|VSSR|插件|基于SSRP开发的更加美观的科学工具|https://github.com/jerrykuku/luci-app-vssr|
|新版argon主题|主题|十分漂亮的OP主题|https://github.com/jerrykuku/luci-theme-argon|
|Argon Config|插件|新版argon主题的设置插件|https://github.com/jerrykuku/luci-app-argon-config|
|广告屏蔽大师Plus+|插件|屏蔽广告插件|lean code source|
|京东签到|插件|白嫖京豆插件|lean code source|
|PushPlus全能推送|插件|钉钉、企业微信推送、Bark、PushPlus各种推送|https://github.com/zzsj0928/luci-app-pushbot|
|网易云音乐Unlock|插件|周杰伦出现在网易云音乐|lean code source|
|UU加速器|插件|土豪玩家必备插件，加速PS5 Switch等|lean code source|
|FRP|插件|内网穿透|lean code source|
|MWAN3|插件|多线的负载均衡|lean code source|
|Transmission|插件|下载器|lean code source|
|Aria2|插件|下载器|lean code source|
|qBittorrent|插件|下载器|lean code source|
|aMule|插件|下载器|lean code source|
|SSR Python Server|服务|SSR服务端|lean code source|
|OpenVPN Server|服务|OpenVPN服务端|lean code source|
|PPTP VPN Server|服务|PPTP VPN服务端|lean code source|
|IPSec VPN Server|服务|IPSec VPN服务端|lean code source|
|ZeroTier|插件|内网穿透工具|lean code source|
|多线多播|插件|多线多播工具|lean code source|
|Turbo ACC|插件|网络加速器|lean code source|
|vim|工具|Linux 系统上一款文本编辑器，它是操作Linux 的一款利器|lean code source|
|nano|工具|比vi/vim要简单得多，比较适合Linux初学者使用|lean code source|
|Openssh-sftp-server|服务|sshd内置的SFTP服务器|lean code source|

## config列表
|适用平台|KERNEL大小|ROOTFS大小|地址|
-|-|-|-
X86平台|128Mb|1024Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/x64.config|
R4S软路由|128Mb|1024Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/R4S.config

## argon主题的背景资源

图片资源：https://github.com/smallprogram/OpenWrtAction/tree/main/source/img
视频资源：https://github.com/smallprogram/OpenWrtAction/tree/main/source/vedio

## 具体功能组件相关截图：
![image](source/function.png)