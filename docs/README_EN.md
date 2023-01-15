
![](https://visitor-badge.glitch.me/badge?style=flat-square&page_id=smallprogram.OpenWrtAction) ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square) ![](https://img.shields.io/github/repo-size/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square) [![](https://img.shields.io/github/license/smallprogram/OpenWrtAction?style=flat-square)](https://github.com/smallprogram/OpenWrtAction/blob/main/LICENSE?style=flat-square)
[![](https://img.shields.io/badge/source%20code-Lean-green?style=flat-square&logo=GitHub)](https://github.com/coolsnowwolf/lede) [![](https://img.shields.io/badge/update%20checker-blueviolet?style=flat-square&logo=Checkmarx)](https://github.com/smallprogram/OpenWrtAction/releases) 

![](https://img.shields.io/github/watchers/smallprogram/OpenWrtAction?style=social) ![](https://img.shields.io/github/forks/smallprogram/OpenWrtAction?style=social) ![](https://img.shields.io/github/stars/smallprogram/OpenWrtAction?style=social)



<!-- ![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/total?style=flat-square)  -->
<!-- ![](https://img.shields.io/github/release-date/smallprogram/OpenWrtAction?style=flat-square) ![](https://img.shields.io/github/last-commit/smallprogram/OpenWrtAction?style=flat-square)  -->

## WorkFlows
|ActionStatus|Network Support|Latest Release|
|-|-|-|
|[![Build-OpenWrt_Multi-Platform](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform.yml/badge.svg)](https://github.com/smallprogram/OpenWrtAction/actions/workflows/Build-OpenWrt_Multi-Platform.yml)|![](https://img.shields.io/badge/-IPv4-green) ![](https://img.shields.io/badge/-IPv6-yellowgreen)|![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/smallprogram/OpenWrtAction?include_prereleases&style=flat-square)|

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
    - [Detailed execution process](#detailed-execution-process)

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
|UU Accelerator|Plugins|A must-have plug-in for local players, to accelerate PS5 Switch, etc.|lean code source|
|FRP|Plugin|Intranet penetration|lean code source|
|MWAN3|Plugin|Multi-line load balancing|lean code source|
|OpenVPN Server|Service|OpenVPN Server|lean code source|
|PPTP VPN Server|Service|PPTP VPN Server|lean code source|
|IPSec VPN Server|Service|IPSec VPN Server|lean code source|
|ZeroTier|Plugin|Intranet penetration tool|lean code source|
|Multi-line multicast|Plugin|Multi-line multicast tool|lean code source|
|Turbo ACC|Plugin|Network Accelerator|lean code source|
|vim|Tools|A text editor on Linux system, it is a powerful tool for operating Linux|lean code source|
|nano|Tools|Much simpler than vi/vim, more suitable for Linux beginners|lean code source|
|Openssh-sftp-server|Service|sshd built-in SFTP server|lean code source|

## config list
|Applicable Platform|KERNEL Size|ROOTFS Size|Address|
-|-|-|-
X86 platform|128Mb|896Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/x64.config|
Pi4_Model_B|128Mb|896Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/Pi4_Model_B.config
R5S soft routing|128Mb|896Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/R5S.config
R4S soft routing|128Mb|896Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/R4S.config
R2S soft routing|128Mb|896Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/R2S.config
R2C soft routing|128Mb|896Mb|https://github.com/smallprogram/OpenWrtAction/blob/main/config/R2C.config

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
bash wsl2op.sh
```
#### Second execution
```shell
cd
cd OpenWrtAction
git pull
bash wsl2op.sh
```

### Detailed execution process
![image](/source/wsl2op.png)
