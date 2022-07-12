#!/bin/bash

echo "========================="
echo "开始 DIY2 配置……"
echo "========================="


#允许ROOT编译
export FORCE_UNSAFE_CONFIGURE=1

# 切换内核版本
#sed -i 's/KERNEL_PATCHVER:=5.15/KERNEL_PATCHVER:=5.4/g' ./target/linux/x86/Makefile

# 修改主机名字，修改你喜欢的就行（不能纯数字或者使用中文）
#sed -i "/uci commit system/i\uci set system.@system[0].hostname='Jejz'" package/lean/default-settings/files/zzz-default-settings
#sed -i "s/hostname='OpenWrt'/hostname='Jejz'/g" ./package/base-files/files/bin/config_generate

# 修改默认IP
sed -i 's/192.168.1.1/192.168.8.3/g' package/base-files/files/bin/config_generate

# 设置密码为空（安装固件时无需密码登陆，然后自己修改想要的密码）
#sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings

# 设置ttyd免帐号登录
sed -i 's/\/bin\/login/\/bin\/login -f root/' feeds/packages/utils/ttyd/files/ttyd.config

# 修改 argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile

#svn co 复制 仓库下的文件夹 git clone 复制整个仓库
# vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr

# serverchan通知
git clone https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

# 关机
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# unblockneteasemusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic

#adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

# filebrowser
svn co https://github.com/Lienol/openwrt-package/trunk/luci-app-filebrowser package/luci-app-filebrowser

#passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall

# passwall2
# svn co https://github.com/xiaorouji/openwrt-passwall2/trunk/luci-app-passwall2 package/luci-app-passwall2

# smartdns
svn co https://github.com/sirpdboy/sirpdboy-package/trunk/luci-app-smartdns package/luci-app-smartdns

# SSRP
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/luci-app-ssr-plus

# openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd

# Themes
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# infinityfreedom 主题
git clone https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom.git package/luci-theme-infinityfreedom

#主机名右上角符号❤
#sed -i 's/❤/❤/g' package/lean/luci-theme-argon_armygreen/luasrc/view/themes/argon_armygreen/header.htm

#修改主题多余版本信息
sed -i 's/<a class=\"luci-link\" href=\"https:\/\/github.com\/openwrt\/luci\">/<a>/g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i "/(<%= ver.luciversion %>)/d" package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/jerrykuku\/luci-theme-argon\">/<a>/g' package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's/<a href=\"https:\/\/github.com\/coolsnowwolf\/luci\">/<a>/g' feeds/luci/themes/luci-theme-bootstrap/luasrc/view/themes/bootstrap/footer.htm

# 显示增加编译时间
sed -i "s/<%=pcdata(ver.luciname)%> (<%=pcdata(ver.luciversion)%>)/ By @Jejz build $(TZ=UTC-8 date "+%Y-%m-%d %H:%M")/g" package/lean/autocore/files/x86/index.htm

# 修改概览里时间显示为中文数字
sed -i 's/os.date()/os.date("%Y年%m月%d日") .. " " .. translate(os.date("%A")) .. " " .. os.date("%X")/g' package/lean/autocore/files/x86/index.htm

# 修改欢迎banner
wget -O ./package/base-files/files/etc/banner https://raw.githubusercontent.com/Jejz168/OpenWrt/main/personal/banner

#固件更新地址
sed -i '/CPU usage/a\                <tr><td width="33%"><%:Compile update%></td><td><a target="_blank" href="https://github.com/Jejz168/OpenWrt/releases">👆查看</a></td></tr>'  package/lean/autocore/files/x86/index.htm
cat >>feeds/luci/modules/luci-base/po/zh-cn/base.po<<- EOF

msgid "Compile update"
msgstr "固件地址"

EOF


# 调整V2ray服务到VPN菜单
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/controller/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/model/cbi/v2ray_server/*.lua
sed -i 's/services/vpn/g' feeds/luci/applications/luci-app-v2ray-server/luasrc/view/v2ray_server/*.htm

# 调整阿里云盘webdav到存储菜单
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-webdav/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-webdav/luasrc/model/cbi/aliyundrive-webdav/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-webdav/luasrc/view/aliyundrive-webdav/*.htm
# 调整阿里云盘fuse到存储菜单
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/controller/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/model/cbi/aliyundrive-fuse/*.lua
sed -i 's/services/nas/g' feeds/luci/applications/luci-app-aliyundrive-fuse/luasrc/view/aliyundrive-fuse/*.htm

# 修改插件名字
# sed -i 's/"挂载 SMB 网络共享"/"挂载共享"/g' `grep "挂载 SMB 网络共享" -rl ./`
# sed -i 's/"Argon 主题设置"/"Argon 设置"/g' `grep "Argon 主题设置" -rl ./`
# sed -i 's/"阿里云盘 WebDAV"/"阿里云盘"/g' `grep "阿里云盘 WebDAV" -rl ./`
# sed -i 's/"USB 打印服务器"/"USB 打印"/g' `grep "USB 打印服务器" -rl ./`
# sed -i 's/网页快捷菜单/端口访问/g' `grep "网页快捷菜单" -rl ./`
# sed -i 's/"网络存储"/"存储"/g' `grep "网络存储" -rl ./`
# sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' `grep "Turbo ACC 网络加速" -rl ./`
# sed -i 's/"实时流量监测"/"流量"/g' `grep "实时流量监测" -rl ./`
# sed -i 's/"KMS 服务器"/"KMS激活"/g' `grep "KMS 服务器" -rl ./`
# sed -i 's/"TTYD 终端"/"命令窗"/g' `grep "TTYD 终端" -rl ./`
# sed -i 's/"USB 打印服务器"/"打印服务"/g' `grep "USB 打印服务器" -rl ./`
# sed -i 's/"Web 管理"/"Web"/g' `grep "Web 管理" -rl ./`
# sed -i 's/"管理权"/"改密码"/g' `grep "管理权" -rl ./`
# sed -i 's/"带宽监控"/"监控"/g' `grep "带宽监控" -rl ./`

echo "========================="
echo " DIY2 配置完成……"
