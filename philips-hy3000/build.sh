#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/lang/golang
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/{luci-app-argon-config,luci-app-dae,luci-app-daed,luci-app-openclash,luci-app-openlist,luci-app-passwall}
rm -rf feeds/packages/net/{dae,daed,xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,mosdns,naiveproxy,open-app-filter,openlist,shadowsocks-libev,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,trojan-plus,tuic-client,v2ray-plugin,xray-plugin,geoview,shadow-tls}

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/new
  cd .. && rm -rf $repodir
}

# Go 26
git clone --depth=1 -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 添加额外插件
git clone --depth=1 -b v5 https://github.com/sbwml/luci-app-mosdns package/new/mosdns
git clone --depth=1 -b main https://github.com/sbwml/luci-app-openlist2 package/new/openlist
git clone --depth=1 -b main https://github.com/MomoFlora/luci-app-adguardhome package/new/adguardhome
git clone --depth=1 -b master https://github.com/destan19/OpenAppFilter package/new/OpenAppFilter

# 科学上网插件
git clone --depth=1 https://github.com/ZeroWrt/openwrt_helloworld package/new/helloworld

# 主题
git clone --depth=1 -b openwrt-25.12 https://github.com/sbwml/luci-theme-argon package/new/luci-theme-argon
git clone --depth=1 -b master https://github.com/MomoFlora/luci-theme-design package/new/luci-theme-design
