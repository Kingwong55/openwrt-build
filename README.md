# 🛡️ ImmortalWrt 旁路由定制固件

基于 **ImmortalWrt 24.10** 的定制 x86_64 旁路由固件，专注于代理、广告拦截和远程组网。

## 📋 快速信息

| 项目 | 值 |
|------|-----|
| **基础固件** | [ImmortalWrt 24.10](https://github.com/immortalwrt/immortalwrt/tree/openwrt-24.10) |
| **目标架构** | x86/64 (EFI) |
| **用途** | ESXi 旁路由（Bypass Router） |
| **编译方式** | GitHub Actions 云端自动编译 |
| **默认 IP** | `10.10.1.2` |

## 🧩 预装插件

| 插件 | 用途 | 后台入口 |
|------|------|---------|
| **OpenClash** | 代理 / 科学上网 | 服务 → OpenClash |
| **AdGuard Home** | DNS 广告拦截 | 服务 → AdGuard Home |
| **Tailscale** | 远程组网 | VPN → Tailscale |
| **EasyTier** | P2P 组网 | VPN → EasyTier |
| **Argon 主题** | 美观 LuCI 界面 | 系统 → Argon 设置 |
| **ttyd** | Web 终端 | 系统 → 终端 |
| **open-vm-tools** | ESXi 虚拟机管理 | — |

## 🌐 网络拓扑

```
                    ┌─────────────┐
     互联网 ────────│  光猫/调制   │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                                     │
 ┌──────┴──────┐                       ┌──────┴──────┐
 │  爱快主路由  │ 10.10.1.1            │ ImmortalWrt  │ 10.10.1.2
 │  (网关/DHCP) │                      │ OpenClash    │
 │  NAT/拨号   │                       │ AdGuard Home │
 └──────┬──────┘                       │ Tailscale    │
        │              LAN 交换机       └──────┬──────┘
        └──────────────────┬──────────────────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         ┌────┴────┐  ┌───┴────┐  ┌────┴────┐
         │ 默认设备 │  │ 科学设备│  │ 其他设备│
         │ 网关 .1 │  │ 网关 .2│  │ 网关 .1 │
         └─────────┘  └────────┘  └─────────┘
```

## 🚀 使用方法

### 下载固件
前往 [Releases](https://github.com/Kingwong55/openwrt-build/releases) 下载最新固件。

### 刷入固件
1. 下载 `immortalwrt-x86-64-generic-squashfs-combined-efi.img.gz`
2. 在现有路由后台 → **系统 → 备份/升级** → 上传固件
3. **不勾选**"保留配置" → 刷入
4. 等待重启，访问 `http://10.10.1.2`

### 手动编译
在 GitHub 仓库 → **Actions** → **Run workflow** → 填入版本号 → 开始编译。

## ⚙️ 编译优化

- **ccache 缓存**：增量编译仅需 ~40 分钟（首次约 2 小时）
- **dl 缓存**：源码包不重复下载
- **自动发布**：编译完成后自动创建 GitHub Release

## ⚠️ 注意事项

- ESXi 网卡建议选择 **VMXNET3**（已内置驱动）
- 默认无密码，首次登录请立即设置 root 密码
- Tailscale 首次使用需 SSH 执行 `tailscale up` 完成认证
