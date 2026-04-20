## 编译时间差异
|编译过程|用时|
|-|-|
从头克隆编译|1h25m22.224s
完整编译过的源码再编译|11m23.553s
删除tmp后再编译|10m33.215s
删除 `build_dir/target-*` `staging_dir/target-*` 再编译|47m46.994s

```bash
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh 
14G     .
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/
host/                             hostpkg/                          toolchain-x86_64_gcc-14.3.0_musl/ 
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/host
1.6G    build_dir/host
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/
host/                             hostpkg/                          toolchain-x86_64_gcc-14.3.0_musl/ 
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/hostpkg/
4.8G    build_dir/hostpkg/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/toolchain-x86_64_gcc-14.3.0_musl/
4.0G    build_dir/toolchain-x86_64_gcc-14.3.0_musl/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh staging_dir/
host/                             hostpkg/                          toolchain-x86_64_gcc-14.3.0_musl/ 
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh staging_dir/host
312M    staging_dir/host
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh staging_dir/hostpkg/
1.6G    staging_dir/hostpkg/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh staging_dir/toolchain-x86_64_gcc-14.3.0_musl/
355M    staging_dir/toolchain-x86_64_gcc-14.3.0_musl/
```


### 编译toolchain、target、host compile容量
```bash
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/
36G     build_dir/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/host
1.6G    build_dir/host
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/hostpkg/
4.8G    build_dir/hostpkg/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/target-x86_64_musl/
25G     build_dir/target-x86_64_musl/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/toolchain-x86_64_gcc-14.3.0_musl/
4.0G    build_dir/toolchain-x86_64_gcc-14.3.0_musl/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/target-x86_64_musl/host/
23G     build_dir/target-x86_64_musl/host/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh build_dir/target-x86_64_musl/linux-x86_64/
2.6G    build_dir/target-x86_64_musl/linux-x86_64/
zhusir@zhusirubuntuserver:~/immortalwrt_openwrt-25.12_X86.config$ du -sh staging_dir/
3.5G    staging_dir/
```