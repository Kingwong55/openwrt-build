# 🛡️ 自定义 OpenWrt 旁路由固件

基于 **ImmortalWrt 24.10** 的定制 x86_64 旁路由固件，专注于代理和广告拦截。

## 📋 快速信息

| 项目 | 值 |
|------|-----|
| **基础固件** | [ImmortalWrt 24.10.6](https://github.com/immortalwrt/immortalwrt/tree/openwrt-24.10) |
| **目标架构** | x86/64 (EFI) |
| **用途** | 旁路由（Bypass Router） |
| **编译方式** | GitHub Actions 云端编译 |

## 🧩 预装插件

| 插件 | 用途 | 来源 |
|------|------|------|
| **OpenClash** | 代理 / 科学上网 | [vernesong/OpenClash](https://github.com/vernesong/OpenClash) |
| **AdGuard Home** | DNS 广告拦截 | [luci-app-adguardhome](https://github.com/rufengsuixing/luci-app-adguardhome) |
| **luci-theme-argon** | 美观 LuCI 主题 | [jerrykuku/luci-theme-argon](https://github.com/jerrykuku/luci-theme-argon) |
| **luci-app-argon-config** | Argon 主题管理器 | [jerrykuku/luci-app-argon-config](https://github.com/jerrykuku/luci-app-argon-config) |
| **ttyd** | Web 终端 | ImmortalWrt 官方源 |
| **Tailscale** | 远程访问组网 (VPN) | ImmortalWrt 官方源 |
| **EasyTier** | P2P 组网（连接朋友家） | [EasyTier/luci-app-easytier](https://github.com/EasyTier/luci-app-easytier) |

## 🌐 网络拓扑

```
                    ┌─────────────┐
     互联网 ────────│  光猫/调制   │
                    └──────┬──────┘
                           │
                    ┌──────┴──────┐
                    │  爱快主路由  │ 10.10.10.1
                    │  (网关/DHCP) │
                    └──┬──────┬───┘
                       │      │
          ┌────────────┘      └────────────┐
          │ 有线 (网关.1)                    │ 无线 (网关.2)
          │ 无广告拦截                       │ 广告拦截 ✅
          │                          ┌──────┴──────┐
          │                          │ OpenWrt 旁路 │ 10.10.10.2
          │                          │ OpenClash    │
          │                          │ AdGuard Home │
          │                          └──────┬──────┘
          │                                 │
     ┌────┴────┐                      ┌─────┴─────┐
     │ 有线设备 │                      │ 无线设备   │
     └─────────┘                      └───────────┘
```

## 🚀 快速开始

```bash
# 1. 启动 Docker Desktop

# 2. 一键编译
./scripts/build.sh

# 3. 固件输出路径
# → output/immortalwrt-x86-64-generic-squashfs-combined-efi.img.gz
```

详细文档请参考 [docs/](./docs/) 目录。

## 📁 项目结构

```
openwrt/
├── README.md                    # 本文件
├── Dockerfile                   # Docker 编译环境
├── docker-compose.yml           # Docker Compose 配置
├── docs/
│   ├── requirements.md          # 插件需求文档
│   ├── build-guide.md           # 编译指南
│   └── network-topology.md      # 网络拓扑说明
├── config/
│   ├── immortalwrt.config       # OpenWrt 编译配置 (.config)
│   └── custom-feeds.conf        # 自定义 feeds 源
├── scripts/
│   ├── build.sh                 # 一键编译脚本
│   └── post-install.sh          # 首次启动后配置脚本
├── files/
│   └── etc/uci-defaults/
│       └── 99-custom-settings   # 首次启动自动配置
├── patches/                     # 自定义补丁（如有）
└── output/                      # 编译产物输出（gitignore）
```

## ⚠️ 注意事项

- 首次编译需要下载大量源码和工具链，耗时约 **1-3 小时**
- 编译过程需要约 **15-20GB** 磁盘空间
- 建议保持稳定的网络连接（需要从 GitHub 等源拉取代码）
