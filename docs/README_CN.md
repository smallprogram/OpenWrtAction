<div align="center">

![](pic/openwrt-logo.jpg)
<h1>OpenWrt — 多平台多设备固件云编译</h1>
</div>




<!-- <p align="center">
    <img src="pic/logo/asus.png" width="90"/> <img src="pic/logo/jdcloud.png" width="90"/> <img src="pic/logo/phicomm.png" width="90"/> <img src="pic/logo/RaspberryPi.png" width="90"/> <img src="pic/logo/rockship.png" width="90"/> <img src="pic/logo/xiaomi.png" width="90"/> <img src="pic/logo/x86.png" width="90"/> <img src="pic/logo/xunlei.png" width="90"/>
</p > -->

<div align="center">

[![Visitors](https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction&countColor=%2344cc11&style=flat-square)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction) ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square) ![](https://img.shields.io/github/repo-size/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square) [![](https://img.shields.io/github/license/smallprogram/OpenWrtAction?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/blob/main/LICENSE?style=flat-square)


</div>

---
[![中文文档](https://img.shields.io/badge/语言-简体中文-blue?style=for-the-badge)](README_CN.md)  [![English Docs](https://img.shields.io/badge/Language-English-green?style=for-the-badge)](README.md)
  <!-- [![SNAPSHOT](https://img.shields.io/badge/Openwrt_Immortalwrt-Snapshot_release_link-green?style=for-the-badge)](https://github.com/0x533512/OpenWrtAction-snapshot/releases) -->

---

## 💻 代码源
<!-- <div align="center">

[![](https://img.shields.io/badge/source-immortalwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/source-lean-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/source-openwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)

</div> -->

[![](https://img.shields.io/badge/source-openwrt_25.12-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)
 ```

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -------------------------------------------------------------------------
 OpenWrt SNAPSHOT, https://github.com/openwrt/openwrt
 -------------------------------------------------------------------------

```

[![](https://img.shields.io/badge/source-immortalwrt_25.12-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt)
```
.___                               __         .__
|   | _____   _____   ____________/  |______  |  |
|   |/     \ /     \ /  _ \_  __ \   __\__  \ |  |
|   |  Y Y  \  Y Y  (  <_> )  | \/|  |  / __ \|  |__
|___|__|_|  /__|_|  /\____/|__|   |__| (____  /____/
          \/      \/  BE FREE AND UNAFRAID  \/
 -------------------------------------------------------------------------
 ImmortalWrt SNAPSHOT, https://github.com/immortalwrt/immortalwrt
 -------------------------------------------------------------------------
```

[![](https://img.shields.io/badge/source-lean_SNAPSHOT-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede)

```
     _________
    /        /\        _    ___ ___  ___
   /  LE    /  \      | |  | __|   \| __|
  /    DE  /    \     | |__| _|| |) | _|
 /________/  LE  \    |____|___|___/|___|
 \        \   DE /
  \    LE  \    /  -------------------------------------------------------
   \  DE    \  /    OpenWrt SNAPSHOT, https://github.com/coolsnowwolf/lede
    \________\/    -------------------------------------------------------
```


---

## ⚙️ 工作流
|ActionStatus|Network Support|Latest Release|Latest Download|
|-|-|-|-|
|[![Build_Multi_Platform(V6)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build_Multi_Platform(V6).yml/badge.svg)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build_Multi_Platform(V6).yml)|![](https://img.shields.io/badge/-IPv4-green) ![](https://img.shields.io/badge/-IPv6-yellowgreen)|![GitHub release (with filter)](https://img.shields.io/github/v/release/smallprogram/OpenWrtAction)|[![GitHub release (latest by date)](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/latest/total?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/releases/latest)|


> 每一个Release包含多个源码平台固件，请根据自己的平台选择对应的固件下载

> 有时候可能某个Release没有你需要的固件，例如找不到X86固件，那有可能是Action中编译失败了，请耐心等待下次编译上传的Release

> 每个Release包含各个平台的packages压缩包，名称格式为buildinfo_[源码平台]_[平台名称]，例如，`buildinfo_immortalwrt_X86`,如果你不想升级固件，只想升级某个ipk可以下载压缩包选择ipk上传至软路由安装即可。

> 详细信息请参考release中的说明
---

## 🌟 特色插件

精选插件配置，涵盖网络加速、主题美化、系统管理等常用功能。

![](https://img.shields.io/badge/Visual_Studio_Code_SSH-Support-green)

### 📡 网络与代理
```
CONFIG_PACKAGE_luci-app-adguardhome=y
CONFIG_PACKAGE_luci-app-ddns-go=y
CONFIG_PACKAGE_luci-app-homeproxy=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_luci-app-nikki=y
CONFIG_PACKAGE_luci-app-smartdns=y
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-upnp=y
CONFIG_PACKAGE_luci-app-udp2raw=y
CONFIG_PACKAGE_luci-app-udpxy=y
CONFIG_PACKAGE_luci-app-cloudflared=y
CONFIG_PACKAGE_luci-app-zerotier=y
```
### ⚙️ 系统管理与工具
```
CONFIG_PACKAGE_luci-app-commands=y
CONFIG_PACKAGE_luci-app-ramfree=y
CONFIG_PACKAGE_luci-app-hd-idle=y
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-cifs-mount=y
CONFIG_PACKAGE_luci-app-uhttpd=y
CONFIG_PACKAGE_luci-app-package-manager=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-netspeedtest=y
CONFIG_PACKAGE_openssh-server=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-wechatpush=y
```

### 📊 流控与监控
```
CONFIG_PACKAGE_luci-app-bandix=y
CONFIG_PACKAGE_luci-app-eqos=y
CONFIG_PACKAGE_luci-app-firewall=y
CONFIG_PACKAGE_luci-app-oaf=y
CONFIG_PACKAGE_luci-app-statistics=y
CONFIG_PACKAGE_luci-app-vnstat2=y
```
### 🛡️ 安全与认证
```
CONFIG_PACKAGE_luci-app-acme=y
CONFIG_PACKAGE_luci-app-arpbind=y
CONFIG_PACKAGE_luci-app-banip=y
```
### 🎨 UI 主题与界面
```
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-theme-kucat=y
CONFIG_PACKAGE_luci-app-kucat-config=y
CONFIG_PACKAGE_luci-theme-aurora=y
CONFIG_PACKAGE_luci-theme-material3=y
CONFIG_PACKAGE_luci-theme-alpha=y
CONFIG_PACKAGE_luci-app-alpha-config=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
CONFIG_PACKAGE_luci-theme-material=y
CONFIG_PACKAGE_luci-theme-openwrt=y
CONFIG_PACKAGE_luci-theme-openwrt-2020=y
```
---

[![Star History Chart](https://api.star-history.com/svg?repos=smallprogram/OpenWrtAction&type=Date)](https://star-history.com/#smallprogram/OpenWrtAction&Date)

---

## 🔗 快速跳转

#### [🧭 最新固件列表，点击自取](https://github.com/smallprogram/OpenWrtAction/tags)
#### [🧭 R1软路由安装ESXi 8.0教程](R1_ESXI8.md)
---
## 📚 相关参数
```
1. 默认地址:`10.10.0.253`
2. 默认账户:`root`
3. 默认密码:`无`
```

---
## 🤖 自动化脚本
### wsl2op.sh本地自动编译shell脚本说明

运行前请确保你的编译环境已经安装要求的编译环境，并且使用非root用户执行。

### 执行编译方式(非Root用户)

#### 首次执行
```shell
git clone https://github.com/smallprogram/OpenWrtAction
cd OpenWrtAction
bash wsl2op.sh
```
#### 二次执行
```shell
cd OpenWrtAction
bash wsl2op.sh
```

---
## ❤️ 致谢

感谢所有使用、反馈和贡献本项目的朋友们！

特别鸣谢以下项目/社区为本项目提供了灵感与支持：

- [immortalwrt](https://github.com/immortalwrt/immortalwrt.git)
- [openwrt](https://github.com/openwrt/openwrt.git)
- [lede](https://github.com/coolsnowwolf/lede)
- 以及社区中的每一位热心用户 ❤️
  

<p align="center">
  <a href="https://github.com/1715173329"><img src="https://github.com/1715173329.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/coolsnowwolf"><img src="https://github.com/coolsnowwolf.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/Beginner-Go"><img src="https://github.com/Beginner-Go.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/graysky2"><img src="https://github.com/graysky2.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/QiuSimons"><img src="https://github.com/QiuSimons.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/Ansuel"><img src="https://github.com/Ansuel.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/nbd168"><img src="https://github.com/nbd168.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/kaloz"><img src="https://github.com/kaloz.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/neheb"><img src="https://github.com/neheb.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
  <a href="https://github.com/Noltari"><img src="https://github.com/Noltari.png" width="75" style="border-radius:10%; margin: 5px;" /></a>
</p>


---
<p align="center">
    <img src="pic/logo/asus.png" width="90"/> <img src="pic/logo/jdcloud.png" width="90"/> <img src="pic/logo/phicomm.png" width="90"/> <img src="pic/logo/RaspberryPi.png" width="90"/> <img src="pic/logo/rockship.png" width="90"/> <img src="pic/logo/xiaomi.png" width="90"/> <img src="pic/logo/x86.png" width="90"/> <img src="pic/logo/xunlei.png" width="90"/>
</p >


