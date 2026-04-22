### 查看镜像
`docker images`

### 删除镜像
`docker rmi id_or_name`

### 查看容器
`docker ps -a`

### 删除容器
`docker rm id_or_name`

### 登录ghcr
`echo "your_token" | docker login ghcr.io -u "smallprogram" --password-stdin`

### 拉取镜像 举例openwrt-base-cache-immortalwrt-x86
`docker pull ghcr.io/smallprogram/openwrt-base-cache-immortalwrt-x86:latest`

### 从镜像创建临时不启动容器temp_bin，默认运行命令 /bin/true,就是啥也不干返回成功
`docker create --name temp_bin ghcr.io/smallprogram/openwrt-base-cache-immortalwrt-x86:latest /bin/true`

### 从容器导出内容到tar,当前目录
`docker export temp_bin > cache_exported.tar`

### 删除容器
`docker rm temp_bin`

### 完整提取GHCR缓存镜像并编译

```bash

rm -rf build_dir staging_dir

docker rm temp_bin

docker pull ghcr.io/smallprogram/openwrt-base-cache-immortalwrt-x86:latest

docker create --name temp_bin ghcr.io/smallprogram/openwrt-base-cache-immortalwrt-x86:latest /bin/true

docker export temp_bin > cache_exported.tar

mkdir -p immcache

tar -xf cache_exported.tar -C immcache --wildcards "op_cache_raw_*" || true

# 2. 探测中转文件夹里是否成功提取到了分块文件
if ls immcache/op_cache_raw_* 1> /dev/null 2>&1; then
   echo "==== 按顺序合并分块并还原到指定目录 ===="
   
   
   # 3. 读取 immcache 里的所有分块，流式合并，并释放到当前目录的配置文件夹下
   cat immcache/op_cache_raw_* | tar -I "zstd -T0" -xf - -C /
   
   # 4. 清理战场：删掉导出的 tar 包，并连锅端掉 immcache 中转站
   rm -f cache_exported.tar
   rm -rf immcache
   
   echo "✅ 缓存合并恢复完成！"
else
   echo "⚠️ 未找到有效缓存分块！"
   # 即使没找到缓存，也顺手把刚才建的空文件夹清掉，保持环境整洁
   rm -rf immcache
fi

time make tools/compile -j$(nproc)
time make toolchain/compile -j$(nproc)
time make target/compile -j$(nproc)

```
