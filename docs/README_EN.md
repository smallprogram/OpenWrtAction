<p align="center">

![](pic/openwrt-logo.jpg)

</p>

<div align="center">

[![Visitors](https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction&countColor=%2344cc11&style=flat-square)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fsmallprogram%2FOpenWrtAction) ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square) ![](https://img.shields.io/github/repo-size/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square) [![](https://img.shields.io/github/license/smallprogram/OpenWrtAction?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/blob/main/LICENSE?style=flat-square)
[![](https://img.shields.io/badge/source%20code-Lean-green?style=flat-square&logo=GitHub)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/update%20checker-blueviolet?style=flat-square&logo=Checkmarx)](https://github.com/smallprogram/OpenWrtAction/releases) 

</div>



<!-- ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square)  -->
<!-- ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square)  -->

## WorkFlows
|ActionStatus|Network Support|Latest Release|Latest Download|
|-|-|-|-|
|[![Build-OpenWrt_Multi-Platform(V2)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform(V2).yml/badge.svg)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform(V2).yml)|![](https://img.shields.io/badge/-IPv4-green) ![](https://img.shields.io/badge/-IPv6-yellowgreen)|[![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/smallprogram/OpenWrtAction?include_prereleases&style=flat-square)](https://github.com/smallprogram/OpenWrtAction/releases/latest)|[![GitHub release (latest by date)](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/latest/total?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/releases/latest)|

# Directory<!-- omit in toc -->

- [Lean Openwrt GitHubAction](#lean-openwrt-githubaction)
    - [Automatically compile according to source code updates](#automatically-compile-according-to-source-code-updates)
  - [Include content](#include-content)
      - [Contains a variety of commonly used plug-ins, the special content is as follows:](#contains-a-variety-of-commonly-used-plug-ins-the-special-content-is-as-follows)
  - [config list](#config-list)
  - [Related screenshots of specific functional components:](#related-screenshots-of-specific-functional-components)
  - [Description of wsl2op.sh local automatic compilation shell script](#description-of-wsl2opsh-local-automatic-compilation-shell-script)
    - [execution way](#execution-way)
      - [First execution](#first-execution)
      - [Second execution](#second-execution)

# Lean Openwrt GitHubAction

![image](/source/login.gif)

![image](/source/login2.jpg)
### Automatically compile according to source code updates


## Include content

#### Contains a variety of commonly used plug-ins, the special content is as follows:


|Name|Type|Introduction|Source address
-|-|-|-
|SSRP|Plugin|The pro son of Lean source code, the evaluation says the most efficient|https://github.com/fw876/helloworld|
|PassWall|Plugin|A powerful scientific tool|https://github.com/xiaorouji/openwrt-passwall|
|PassWall2|Plugin|A powerful scientific tool|https://github.com/xiaorouji/openwrt-passwall2|
|OpenClash|Plugin|Scientific tools with a high degree of configuration freedom|https://github.com/vernesong/OpenClash|
|DockerMan|Plugin|The essential plug-in for playing Docker on OP|https://github.com/lisaac/luci-app-dockerman|
|New version of argon theme|Theme|Very beautiful OP theme|https://github.com/jerrykuku/luci-theme-argon|
|Argon Config|Plugin|Settings plugin for the new version of argon theme|https://github.com/jerrykuku/luci-app-argon-config|
|AdguardHome|plugin|blocking ad plugin|https://github.com/rufengsuixing/luci-app-adguardhome.git|
|Ad Blocking Master Plus+|Plugin|Block Ad Plugin|lean code source|
|Jingdong Sign-in|Plugin|White Prostitution Jingdou Plugin|lean code source|
|PushPlus Almighty Push|Plugin|DingTalk, Enterprise WeChat Push, Bark, PushPlus Various Push|https://github.com/zzsj0928/luci-app-pushbot|
|NetEase Cloud Music Unlock|Plugin|Jay Chou appeared in NetEase Cloud Music|lean code source|
|FRP|Plugin|Intranet penetration|lean code source|
|MWAN3|Plugin|Multi-line load balancing|lean code source|
|OpenVPN Server|Service|OpenVPN Server|lean code source|
|PPTP VPN Server|Service|PPTP VPN Server|lean code source|
|IPSec VPN Server|Service|IPSec VPN Server|lean code source|
|SmartDNS|Service|DNS Service|lean code source|
|MosDNS|Service|DNS Service|https://github.com/sbwml/luci-app-mosdns|
|ZeroTier|Plugin|Intranet penetration tool|lean code source|
|Multi-line multicast|Plugin|Multi-line multicast tool|lean code source|
|Turbo ACC|Plugin|Network Accelerator|lean code source|
|vim|Tools|A text editor on Linux system, it is a powerful tool for operating Linux|lean code source|
|nano|Tools|Much simpler than vi/vim, more suitable for Linux beginners|lean code source|
|Openssh-sftp-server|Service|sshd built-in SFTP server|lean code source|

## config list
|Applicable Platform|KERNEL Size|ROOTFS Size|Address|
-|-|-|-
![](https://img.shields.io/badge/OpenWrt-X86_64-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/X86.config)|
![](https://img.shields.io/badge/OpenWrt-H66K-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/H66K.config)|
![](https://img.shields.io/badge/OpenWrt-H68K-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/H68K.config)|
![](https://img.shields.io/badge/OpenWrt-H69K-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/H69K.config)|
![](https://img.shields.io/badge/OpenWrt-R5S-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R5S.config)|
![](https://img.shields.io/badge/OpenWrt-R5C-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R5C.config)|
![](https://img.shields.io/badge/OpenWrt-R4S-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R4S.config)|
![](https://img.shields.io/badge/OpenWrt-R4SE-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R4SE.config)|
![](https://img.shields.io/badge/OpenWrt-R2S-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R2S.config)|
![](https://img.shields.io/badge/OpenWrt-R2C-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R2C.config)|
![](https://img.shields.io/badge/OpenWrt-R66S-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R66S.config)|
![](https://img.shields.io/badge/OpenWrt-R68S-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R68S.config)|
![](https://img.shields.io/badge/OpenWrt-RPi3B-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R_PI_3b.config)|
![](https://img.shields.io/badge/OpenWrt-RPi4B-32C955.svg?logo=openwrt)|![](https://img.shields.io/badge/kernel-256Mb-orange.svg?logo=sequelize&color=#4285F4)|![](https://img.shields.io/badge/rootfs-1024Mb-orange.svg?logo=webpack&color=#4285F4)|[![](https://img.shields.io/badge/config-file-orange.svg?logo=apache-spark)](https://github.com/smallprogram/OpenWrtAction/blob/main/config/R_PI_4b.config)|


## Related screenshots of specific functional components:
![image](/source/main.png)


## Description of wsl2op.sh local automatic compilation shell script

Before running, please make sure that your compilation environment has been installed with the compilation environment required in the Lean source code and executed as a non-root user.



Note that if you fork my Respository, you need to synchronize the modified config back to github,

First you need to **modify the value of the owaUrl variable in the wsl2op.sh script to change it to the git Url after you fork**

![image](/source/owaUrl.png)

Then you need to enter <b>github username</b> and <b>github Token</b>

**github Token, please create it in your own Github Settings --> Developer settings --> Personal access tokens**

![image](/source/githubauth.png)

Of course, if you find it troublesome, you can also directly PR your config to my warehouse config folder, so you can directly compile asynchronously

### execution way
#### First execution
```shell
cd
git clone https://github.com/smallprogram/OpenWrtAction.git
cd OpenWrtAction
bash wsl2op_lean.sh
```
#### Second execution
```shell
cd
cd OpenWrtAction
git pull
bash wsl2op_lean.sh
```


