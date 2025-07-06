<div align="center">

![](pic/openwrt-logo.jpg)
<h1>OpenWrt — Multi-Platform Firmware Cloud Compilation</h1>
</div>




<!-- <p align="center">
    <img src="pic/logo/asus.png" width="90"/> <img src="pic/logo/jdcloud.png" width="90"/> <img src="pic/logo/phicomm.png" width="90"/> <img src="pic/logo/RaspberryPi.png" width="90"/> <img src="pic/logo/rockship.png" width="90"/> <img src="pic/logo/xiaomi.png" width="90"/> <img src="pic/logo/x86.png" width="90"/> <img src="pic/logo/xunlei.png" width="90"/>
</p > -->

<div align="center">

[![Visitors](https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction&countColor=%2344cc11&style=flat-square)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction) ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square) ![](https://img.shields.io/github/repo-size/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square) [![](https://img.shields.io/github/license/smallprogram/OpenWrtAction?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/blob/main/LICENSE?style=flat-square)


</div>

---
[![中文文档](https://img.shields.io/badge/语言-简体中文-blue?style=for-the-badge)](README_CN.md)  [![English Docs](https://img.shields.io/badge/Language-English-green?style=for-the-badge)](README_EN.md)

---

## 💻 Source Code Platform
<!-- <div align="center">

[![](https://img.shields.io/badge/source-immortalwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/source-lean-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/source-openwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)

</div> -->

[![](https://img.shields.io/badge/source-immortalwrt-blue?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt)
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
[![](https://img.shields.io/badge/source-openwrt-blue?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)
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
 [![](https://img.shields.io/badge/source-lean-blue?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede)

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

## ⚙️ WorkFlow
|ActionStatus|Network Support|Latest Release|Latest Download|
|-|-|-|-|
|[![Build-OpenWrt_Multi-Platform(V4)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform(V4).yml/badge.svg?branch=main)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform(V4).yml)|![](https://img.shields.io/badge/-IPv4-green) ![](https://img.shields.io/badge/-IPv6-yellowgreen)|![GitHub release (with filter)](https://img.shields.io/github/v/release/smallprogram/OpenWrtAction)|[![GitHub release (latest by date)](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/latest/total?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/releases/latest)|


> Each Release contains multiple source platform firmwares. Please select the corresponding firmware download according to your platform.
> Sometimes a Release may not have the firmware you need, for example, the X86 firmware cannot be found. It may be that the compilation in the Action failed. Please wait patiently for the next compiled and uploaded Release.
> Each Release contains the package compression package of each platform. The name format is buildinfo_[source platform]_[platform name]. For example, `buildinfo_immortalwrt_X86`. If you do not want to upgrade the firmware, but only want to upgrade a certain ipk, you can download the compressed package and select the ipk to upload to the soft router for installation.
> For more information, please refer to the instructions in the release
---
## 🌟 Featured Plugins

Selected plug-in configuration, covering common functions such as network acceleration, theme beautification, system management, etc.

### 📡 Network and Agent
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
```
### ⚙️ System Management and Tools
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
CONFIG_PACKAGE_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-app-wechatpush=y
```

### 📊 Flow control and monitoring
```
CONFIG_PACKAGE_luci-app-eqos=y
CONFIG_PACKAGE_luci-app-sqm=y
CONFIG_PACKAGE_luci-app-nft-qos=y
CONFIG_PACKAGE_luci-app-firewall=y
CONFIG_PACKAGE_luci-app-statistics=y
CONFIG_PACKAGE_luci-app-vnstat2=y
```
### 🛡️ Security and Authentication
```
CONFIG_PACKAGE_luci-app-acme=y
CONFIG_PACKAGE_luci-app-arpbind=y
```
### 🎨 UI Themes and Interfaces
```
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-theme-bootstrap=y
CONFIG_PACKAGE_luci-theme-material=y
CONFIG_PACKAGE_luci-theme-openwrt=y
CONFIG_PACKAGE_luci-theme-openwrt-2020=y
CONFIG_PACKAGE_luci-app-argon-config=y
```
---

[![Star History Chart](https://api.star-history.com/svg?repos=smallprogram/OpenWrtAction&type=Date)](https://star-history.com/#smallprogram/OpenWrtAction&Date)

---

## 🔗 Quick Jump
#### [🧭 Latest firmware list, click to get it](https://github.com/smallprogram/OpenWrtAction/tags)
#### [🧭 R1 Soft Router Installation ESXi 8.0 Tutorial](R1_ESXI8.md)
---
## 📚 Related parameters
```
1. Default address:`10.10.0.253`
2. Default account:`root`
3. Default password:`None`
```

---
## 🤖 Automation script
### wsl2op.sh local automatic compilation shell script description

Before running, please make sure that your compilation environment has installed the required compilation environment and use a non-root user to execute.

### Execution compilation method (non-root user)

#### First execution
```shell
git clone https://github.com/smallprogram/OpenWrtAction
cd OpenWrtAction
bash wsl2op.sh
```
#### Second execution
```shell
cd OpenWrtAction
bash wsl2op.sh
```
---
## ❤️ Acknowledgements

Thanks to everyone who used, contributed to, and contributed to this project!

Special thanks to the following projects/communities for providing inspiration and support for this project:

- [immortalwrt](https://github.com/immortalwrt/immortalwrt.git)
- [openwrt](https://github.com/openwrt/openwrt.git)
- [lede](https://github.com/coolsnowwolf/lede)
- And every enthusiastic user in the community ❤️

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


