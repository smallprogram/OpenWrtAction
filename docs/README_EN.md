<p align="center">

![](pic/openwrt-logo.jpg)

</p>




<p align="center">
    <img src="pic/logo/asus.png" width="90"/> <img src="pic/logo/jdcloud.png" width="90"/> <img src="pic/logo/phicomm.png" width="90"/> <img src="pic/logo/RaspberryPi.png" width="90"/> <img src="pic/logo/rockship.png" width="90"/> <img src="pic/logo/xiaomi.png" width="90"/> <img src="pic/logo/x86.png" width="90"/> <img src="pic/logo/xunlei.png" width="90"/>
</p >

<div align="center">

[![Visitors](https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction&countColor=%2344cc11&style=flat-square)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction) ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square) ![](https://img.shields.io/github/repo-size/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square) [![](https://img.shields.io/github/license/smallprogram/OpenWrtAction?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/blob/main/LICENSE?style=flat-square)


</div>


<!-- ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square)  -->
<!-- ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square)  -->

## Source Code Information
<!-- <div align="center">

[![](https://img.shields.io/badge/sorce-immortalwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt) [![](https://img.shields.io/badge/sorce-lean-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/sorce-openwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)

</div> -->

[![](https://img.shields.io/badge/source-immortalwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/immortalwrt/immortalwrt)
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
[![](https://img.shields.io/badge/source-openwrt-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/openwrt/openwrt)
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
 [![](https://img.shields.io/badge/source-lean-green?logo=openwrt&logoColor=green&style=flat-square)](https://github.com/coolsnowwolf/lede)

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

## WorkFlows
|ActionStatus|Network Support|Latest Release|Latest Download|
|-|-|-|-|
|[![Build-OpenWrt_Multi-Platform(V3)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform(V3).yml/badge.svg?branch=main)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform(V3).yml)|![](https://img.shields.io/badge/-IPv4-green) ![](https://img.shields.io/badge/-IPv6-yellowgreen)|![GitHub release (with filter)](https://img.shields.io/github/v/release/smallprogram/OpenWrtAction)|[![GitHub release (latest by date)](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/latest/total?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/releases/latest)|

> Each Release contains multiple source platform firmwares. Please select the corresponding firmware download according to your platform

> Sometimes a Release may not have the firmware you need, for example, the X86 firmware cannot be found. It may be that the compilation in the Action failed. Please wait patiently for the next compiled and uploaded Release

> Each Release contains the package compression package of each platform. The name format is buildinfo_[source platform]_[platform name], for example, `buildinfo_immortalwrt_X86`. If you do not want to upgrade the firmware, but only want to upgrade a certain ipk, you can download the compressed package and select the ipk to upload to the soft router for installation.

> For more information, please refer to the instructions in the release

[![Star History Chart](https://api.star-history.com/svg?repos=smallprogram/OpenWrtAction&type=Date)](https://star-history.com/#smallprogram/OpenWrtAction&Date)


## wsl2op.sh local automatic compilation shell script description

Before running, please make sure that your compilation environment has installed the required compilation environment and use a non-root user to execute.

### Execution compilation method (non-root user)

```shell
bash wsl2op.sh
```
