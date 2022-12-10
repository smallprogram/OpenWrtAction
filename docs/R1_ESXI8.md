# 酷硬R1 安装 ESXI 8
![image](pic/R1_ESXI8/banner.png)

这个小主机很不错，入手之后就开始折腾，对于一颗N6005的U来说，不做虚拟化就太浪费了。到货后系统再带PVE和ESir的固件，用了用感觉也挺好，但是，不折腾一下怎么对得起这机器呢。

经过一系列的折腾，ESXI 8除了TPM以外基本兼容R1，网卡、NVMe等设备驱动完美支持，无需自己封装驱动，这点非常好。

把相关操作记录一下，为需要的人做个参考。

# 目录

- [酷硬R1 安装 ESXI 8](#酷硬r1-安装-esxi-8)
- [目录](#目录)
  - [准备工作](#准备工作)
    - [ESXI 8 安装文件](#esxi-8-安装文件)
    - [ventoy写盘工具](#ventoy写盘工具)
    - [Openwrt固件](#openwrt固件)
    - [StarWind V2V Converter程序](#starwind-v2v-converter程序)
  - [安装步骤](#安装步骤)
    - [ventoy写盘](#ventoy写盘)
    - [ESXI挂载](#esxi挂载)
    - [ESXI安装(重点)](#esxi安装重点)
    - [ESXI后台配置](#esxi后台配置)
  - [ESXI前台配置](#esxi前台配置)
    - [基础设置](#基础设置)
    - [网络设置](#网络设置)
    - [配置OPENWRT虚拟机](#配置openwrt虚拟机)



## 准备工作
- esxi 8 安装程序
- ventoy写盘工具
- Openwrt固件
- StarWind V2V Converter程序
- 键盘鼠标和USB Hub
- 8GB+容量U盘一个

如果你懒得下载，可以用我下载好的文件，[点击此处(OneDrive)](https://1drv.ms/u/s!AjMAohXqVY4TgZV2lm2JJg6E3YWNTA?e=bwBWA8)


### ESXI 8 安装文件
可以直接去官网下载，地址：https://customerconnect.vmware.com/evalcenter?p=vsphere-eval-8 ，注意，你需要注册一个VMWare的customer connect账号，注册登录完毕后，就可以下载60天试用版的ESXI8.0了，至于怎么激活可以问问Google，

![image](pic/R1_ESXI8/ESXI8Downlaod.png)

可直接下载ISO镜像即可，如果你需要封装驱动，那就下载Offline Bundle离线捆绑包，驱动封装不在本次讨论范围内。

至于vCenter Server，实在太大，绝大多数功能都用不上，就不用管他了。

### ventoy写盘工具
下载地址：https://github.com/ventoy/Ventoy/releases ，该工具目前为1.0.84版本，release中下载windows平台即可

### Openwrt固件
这个不用多说了。要么你自己编译，要么用别人编译好的都可以，只要X86就行，比如ESir的高大全版，或者我这个仓库的X86也可以，https://github.com/smallprogram/OpenWrtAction/ ，不过建议使用efi模式的VMDK固件。

![image](pic/R1_ESXI8/OPRelease.png)

### StarWind V2V Converter程序
该程序用于将OP固件VMDK文件转换为ESXI 8.0的存储格式，如果直接用VMDK，ESXI 8.0将无法挂载镜像。下载地址：https://www.starwindsoftware.com/starwind-v2v-converter ，下载需要填写邮箱，下载地址会发送到你的邮箱里。
![image](pic/R1_ESXI8/starwind-v2v-converter.png)

后续硬件设备请你自己备齐。

## 安装步骤

将显示器，键盘鼠标在一个USB Hub上，接入R1，R1中你喜欢的某个网口与PC网卡连接。

### ventoy写盘

1. U盘插入PC
2. 电脑运行Ventoy2Disk.exe
3. Ventoy配置选项中将分区类型改为GPT,安全启动支持打勾

![image](pic/R1_ESXI8/ventoy.png)

4. 设备选择U盘设备
5. 点击安装，等待安装完成，关闭Ventoy程序
6. 将下载好的ESXI镜像文件拷贝至U盘，完成后拔出U盘

### ESXI挂载

1. 将U盘插入R1剩余的U口
2. 开机F12选在U盘启动
3. 进入Ventoy，选择ESXI镜像引导

### ESXI安装(重点)

ESXI开始引导后，屏幕出现跑码界面,注意，看到跑码界面，马上按键盘上的Shift+o,欧键，在屏幕下方删除多余命令，手工录入命令`cdromBoot runweasel autoPartitionOSDataSize=4096`,注意区分大小写。录入完成后回车继续。

这个命令的意思是安装ESXI时，系统占用空间为4096MB,也就是4GB，如果不录入该命令，ESXI8.0默认会让VMFSL系统分区占用100多个G，可用的VMFS就没多少了。当然如果你的R1硬盘足够大，不录入也可以

![image](pic/R1_ESXI8/esxiinsatll1.png)

![image](pic/R1_ESXI8/esxiinsatll2.png)

后续安装，ESXI会扫描磁盘，选择R1自带的硬盘，之后设置root账号的密码，确认安装信息，最后重启设备

![image](pic/R1_ESXI8/esxiinsatll3.png)
![image](pic/R1_ESXI8/esxiinsatll4.png)

### ESXI后台配置

安装完成后，会进入一个后台配置界面。

![image](pic/R1_ESXI8/esxiinsatll5.png)

按F2进入后台配置界面，输入root账号密码，挑个网口作为管理口，与PC机连接

![image](pic/R1_ESXI8/esxiinsatll6.png)

通过Configure Management Network配置网络，选择Network Adapters,配置管理口

![image](pic/R1_ESXI8/esxiinsatll7.png)

进入后会发现，其中一个网卡状态为connected，就是接入网线的网口，注意，此处只能选择一个网口作为管理口，不要选择多个，例如图中，选择vmnic3网口，空格为选择或取消，配置完成回车保存，esc退回上级菜单，有可能会提示你是否保存，选择是即可

![image](pic/R1_ESXI8/esxiinsatll8.png)

返回上级菜单后，选择IPv4 Configuration，配置管理口的静态管理IP，用于未来访问esxi。


![image](pic/R1_ESXI8/esxiinsatll9.png)

选择静态IP，配置为你网络环境中的内网网段IP即可，一般配置为孤僻IP，例如254，253，也可随意配置，只要你记得住就行，网关为你路由器的IP，如果将Openwrt做入ESXI中的话，就配置为Openwrt路由的IP，比如我的固件Openwrt的默认IP为10.10.0.253，那么此处Gateway网关就填入10.10.0.253.

![image](pic/R1_ESXI8/esxiinsatll10.png)

最后esc退出，会弹出确认提示，Y即可。

![image](pic/R1_ESXI8/esxiinsatll11.png)

退回到主界面

## ESXI前台配置

在PC端，输入之前后台配置的IP地址，访问ESXI Web管理端，我配置的是10.10.0.254

### 基础设置

![image](pic/R1_ESXI8/esxisetup01.png)

ESXI 8.0首页

![image](pic/R1_ESXI8/esxisetup02.png)

开启自动启动策略

![image](pic/R1_ESXI8/esxisetup03.png)

PCI设备 设置中，可以切换硬件是否直通，这个后边会说到

![image](pic/R1_ESXI8/esxisetup04.png)

电源管理中，启用高性能

![image](pic/R1_ESXI8/esxisetup05.png)

许可中，激活ESXI，序列号我没有，你们自己找，嘿嘿嘿。。

![image](pic/R1_ESXI8/esxisetup06.png)

### 网络设置

虚拟交换机，系统默认带了一个虚拟交换机，需要再继续添加其余三个

![image](pic/R1_ESXI8/esxisetup07.png)

例如vSwitch0虚拟交换绑定的上行链路为物理网卡0口

![image](pic/R1_ESXI8/esxisetup08.png)

同理，vSwitch1虚拟交换绑定的上行链路为物理网卡1口，按照这个逻辑，将剩余的网口一次绑定到独立的虚拟交换机上

![image](pic/R1_ESXI8/esxisetup09.png)

每一个vSwitch虚拟交换中的安全选项中，都需要开启混杂模式、MAC地址变更、伪传输。如果不开启会出现问题，造成网卡间不能通讯，网络故障等。

![image](pic/R1_ESXI8/esxisetup10_1.png)

虚拟交换机维护完毕后，回到端口组，对应添加四个虚拟网络。

![image](pic/R1_ESXI8/esxisetup10.png)

例如VM Network绑定交换机vSwitch0,VM Network1绑定交换机vSwitch1。

![image](pic/R1_ESXI8/esxisetup11.png)

![image](pic/R1_ESXI8/esxisetup12.png)

最终的效果就是物理网卡0口，通过vSwitch0虚拟交换机绑定到VM Network虚拟网络上，最后虚拟机使用VM Network虚拟网络进行通信

![image](pic/R1_ESXI8/esxisetup13.png)

下面是整体网络拓补图，概括为物理网卡---->虚拟交换机----->虚拟网络----->虚拟机，
其中有个特数据的网络，Management Network,这个是ESXI的管理口网络，默认绑定到前面后台设置时的虚拟交换机上。这个口是无法做硬件直通的，如果这个口做了硬件直通，那你以后就再也无法访问ESXI Web管理界面了。

这种非直通的方案好处在于，你可以用多个虚拟机共享同一网口的网络，性能也很好。

![image](pic/R1_ESXI8/esxisetup14.png)

下面这张图，是2、3口做了网卡直通后的效果，2、3口绕过了之前的虚拟网络环节，直接与虚拟机进行通信，效率会高一些，但是缺点十分明显，2、3口直通后就只能被单一虚拟机使用了。并且2、3口无法访问ESXI管理后台。

我个人认为，为了提升那么一点点的网络性能，做直通是完全没有必要的，ESXI 8对网络进行了大量优化，目前直通与非直通的效率几乎一致。

![image](pic/R1_ESXI8/esxisetup15.png)

### 配置OPENWRT虚拟机

选择虚拟机选项卡，点击创建/主次虚拟机

![image](pic/R1_ESXI8/esxisetup16.png)

![image](pic/R1_ESXI8/esxisetup17.png)

名称按你喜欢的取，客户机系统选择Linux，版本选择6.x或更高

![image](pic/R1_ESXI8/esxisetup18.png)

![image](pic/R1_ESXI8/esxisetup19.png)

自定义设置中，将硬盘删掉，点后边的×，将CD驱动器也删掉，这个用不到

![image](pic/R1_ESXI8/esxisetup20.png)

点击添加网络设配器，将其余三个虚拟网络添加上，每个适配器类型选择VMXNET 3 万兆类型

![image](pic/R1_ESXI8/esxisetup21.png)

虚拟机选项中，引导选项，UEFI安全引导取消掉。由于我们用的是EFI固件，引导模式默认EFI就可以了

![image](pic/R1_ESXI8/esxisetup22.png)

完成后这个虚拟最终配置如下，没有硬盘。

![image](pic/R1_ESXI8/esxisetup23.png)

回到电脑桌面，运行StarWind V2V Converter, 选择Local File,选择本地文件

![image](pic/R1_ESXI8/esxisetup24.png)

找到efi的vmdk固件并选择

![image](pic/R1_ESXI8/esxisetup25.png)

![image](pic/R1_ESXI8/esxisetup26.png)

转换目标地址选择 Remote VMware ESXi Server ov vCenter, 该选项会将转换后的vmdk直接发送到ESXi的虚拟机上

![image](pic/R1_ESXI8/esxisetup27.png)

填入ESXi的IP，root用户名密码

![image](pic/R1_ESXI8/esxisetup28.png)

如果没错，会显示出ESXi远程平台上的虚拟机，选择刚才创建的Openwrt，Next

![image](pic/R1_ESXI8/esxisetup29.png)

选择转换后的VMDK类型，默认growable image就可以

![image](pic/R1_ESXI8/esxisetup30.png)

![image](pic/R1_ESXI8/esxisetup31.png)

等待转换完毕

![image](pic/R1_ESXI8/esxisetup32.png)

![image](pic/R1_ESXI8/esxisetup33.png)

转换并上传完毕后，通过ESXI后台存储浏览，可以看到Openwrt下已经有了转换后的vmdk，

![image](pic/R1_ESXI8/esxisetup34.png)

回到虚拟Openwrt下，编辑，会看到转换后的vmdk硬件已经自动挂载到虚拟机上了。这时，你只需要点击打开电源，你的Openwrt虚拟机就算做好了。之后的OP设置就可以通过浏览器去设置了。

![image](pic/R1_ESXI8/esxisetup35.png)

最后说一下，如果要虚拟机开启自动启动，按下图操作即可。

![image](pic/R1_ESXI8/esxisetup36.png)

