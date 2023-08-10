## :mega:Update content
![](https://img.shields.io/github/downloads/smallprogram/OpenWrtAction/multi-platform_2023.08.15_15.01.44/total?style=flat-square)
### Firmware Information
**:loudspeaker:Cancel the ext4 format and only keep the squashfs format.**
**:computer:Including traditional IMG format firmware and UEFI boot firmware.**
**:cd:Including qcow2 format firmware and UEFI boot firmware supporting pve virtual machine.**
**:cd:Including vdi format firmware and UEFI boot firmware supporting Visual Box virtual machine.**
**:cd:Including vhdx format firmware and UEFI boot firmware supporting Hyper-v virtual machines.**
**:dvd:Including vmdk format firmware and UEFI boot firmware that support ESXi virtual machines (8.0 requires tool conversion).**

### Openwrt Information
**:minidisc: OpenWrt Version: R23.7.7**
**:gear: Default-Setting Version: 3.2**
### Compile Information
platform|kernel|compile status
-|-|-
**:ice_cube: X86**|**6.1.44**|![](https://img.shields.io/badge/build-passing-green?logo=githubactionsbuild-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellowlogoColor=green&style=flat-square)
**:ice_cube: R5S**|**5.15.122**|![](https://img.shields.io/badge/build-passing-green?logo=githubactionsbuild-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellowlogoColor=green&style=flat-square)
**:ice_cube: R4S**|**5.15.122**|![](https://img.shields.io/badge/build-passing-green?logo=githubactionsbuild-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellowlogoColor=green&style=flat-square)
**:ice_cube: R2S**|**5.15.122**|![](https://img.shields.io/badge/build-passing-green?logo=githubactionsbuild-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellowlogoColor=green&style=flat-square)
**:ice_cube: R2C**|**5.15.122**|![](https://img.shields.io/badge/build-passing-green?logo=githubactionsbuild-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellowlogoColor=green&style=flat-square)
**:ice_cube: Pi4ModelB**|**5.15.122**|![](https://img.shields.io/badge/build-failure-red?logo=githubactionsbuild-in_progress_or_waiting.....-yellow?logo=githubactions&logoColor=yellowlogoColor=red&style=flat-square)
## What's Changed
<details> <summary> Lean Openwrt Commit Top 1 </summary>
commit 4e7c56f9f3a07afef5e59b2c204d884aa83aeeb7
Author: 晓东 <1052672227@qq.com>
Date:   Tue Aug 15 14:32:55 2023 +0800

    Support emmc for Thunder OneCloud (#11453)
</details> <details> <summary> Lean Package Commit Top 1 </summary>
commit 5ffee9290660232b60ec3b524e5ffdbc0b82b01c
Author: coolsnowwolf <31687149+coolsnowwolf@users.noreply.github.com>
Date:   Sat Jun 24 23:26:03 2023 +0800

    Merge pull request #679 from littoy/patch
    
    qemu io_uring feature and bonding patches
</details> <details> <summary> Lean Luci Commit Top 1 </summary>
commit 7acf7ff40a398af1075180754c7e32f856e67f2f
Author: coolsnowwolf <coolsnowwolf@gmail.com>
Date:   Mon Aug 14 18:44:07 2023 +0800

    luci-compat: fix compatibility with v19.07.7
</details> <details> <summary> Openwrt routing Commit Top 1 </summary>
commit 5beb3be9b86ddd1e859dd9ad38d1fb9a1a32dc65
Author: Rob White <rob@blue-wave.net>
Date:   Mon Jul 31 21:33:11 2023 +0100

    mesh11sd: Release v2.0.0
    
    Maintainer: Rob White rob@blue-wave.net
    Compile tested: All
    Run tested: arm_cortex-a7_neon-vfpv4, mipsel_24kc, x86-64, on 21.02, 22.03 and snapshot.
    
    Description:
    mesh11sd (2.0.0)
    
    This release contains new functionality.
    
    Autonomous portal mode is introduced. This simplifies the rollout of meshnodes allowing a common configuration to be used on all nodes.
    Remote administration is introduced, allowing files to be copied and terminal sessions to be opened on established meshnodes, identifying remote nodes by mac address.
    
     * Add - Update config file [bluewavenet]
     * Add - implementation of remote copy [bluewavenet]
     * Add - implementation of remote connect [bluewavenet]
     * Add - Autonomous portal mode [bluewavenet]
    
    -- Rob White dot@blue-wave.net Mon, 31 Jul 2023 16:59:52 +0000
    
    
    Signed-off-by: Rob White <rob@blue-wave.net>
</details> <details> <summary> Openwrt telephony Commit Top 1 </summary>
commit c093d20a53afda4a0fe79c25a14406617018f57c
Author: micmac1 <sebastian_ml@gmx.net>
Date:   Sun Jul 23 15:45:02 2023 +0200

    Merge pull request #822 from micmac1/ast-iax2-crash
    
    asterisk: add upstream patch against iax2 crash
</details> <details> <summary> SSRP Commit Top 1 </summary>
commit f2c18e487aaf4e9e06e4f64ba6a0c82a7a384b74
Author: coolsnowwolf <31687149+coolsnowwolf@users.noreply.github.com>
Date:   Sun Aug 13 04:00:08 2023 +0800

    Update ssr-plus.po
</details> <details> <summary> Passwall Packages Commit Top 1 </summary>
commit 6a3e32a02549496a7221ad265df963911a688732
Author: Gzxhwq <Gzxhwq@users.noreply.github.com>
Date:   Mon Aug 7 14:26:59 2023 +0800

    sing-box: update to 1.3.6 (#2692)
</details> <details> <summary> Passwall Luci Commit Top 1 </summary>
commit f16065f40b501c51383866b38552d3d04b8effff
Author: xiaorouji <60100640+xiaorouji@users.noreply.github.com>
Date:   Sat Aug 12 02:24:52 2023 +0800

    luci: fixup 5891a6b
</details> <details> <summary> Passwall2 Commit Top 1 </summary>
commit 17e090453558dfda9fde6c6f0e1a480680a81473
Author: xiaorouji <60100640+xiaorouji@users.noreply.github.com>
Date:   Sat Aug 12 02:19:00 2023 +0800

    luci: 1.18
</details> <details> <summary> OpenClash Commit Top 1 </summary>
commit 3952a3d4ea3728c1c929d0a92a4e0dcf2c7b7c2a
Author: github-actions[bot] <github-actions[bot]@users.noreply.github.com>
Date:   Tue Jul 4 08:37:40 2023 +0000

    Auto Release: v0.45.129-beta
