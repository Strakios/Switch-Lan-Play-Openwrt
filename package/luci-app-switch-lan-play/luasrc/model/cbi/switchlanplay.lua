-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs" 
local sys = require "luci.sys"
local m, s

local play_on = (luci.sys.call("pidof lan-play > /dev/null"))==0

local state_msg = " "

if play_on then
    local now_server = io.popen("ps | grep lan-play | grep -v 'grep' | cut -d ' ' -f 14")
    local server_info = now_server:read("*all")
    now_server:close()
    state_msg="<b><font color=\"green\">" .. translate("Running") .. "</font></b>"  .. "<br /><br />Current Server Address    " .. server_info
else
    state_msg="<b><font color=\"red\">" .. translate("Stopped")  .. "</font></b>"
end

m = Map("switchlanplay", translate("Switch LAN Play"),
	translatef("Play local wireless Switch games over the Internet.") .. "<br /><br />" ..translate("Service status:") .. " - " .. state_msg)

s = m:section(TypedSection, "switch-lan-play", translate("Settings"))
s.addremove = false
s.anonymous = true

s:option(Flag, "enable", translate("Enabled"), translate("Enables or disables the switch-lan-play daemon."))

ifname = s:option(ListValue, "ifname", translate("Interfaces"), translate("Specifies the interface to listen on."))

for k, v in ipairs(luci.sys.net.devices()) do
    if v ~= "lo" then
        ifname:value(v)
    end
end

relay_server_ip = s:option(Value, "relay_server_ip", translate("relay_server_ip"), translate("Server IP Address (Required)"))
    relay_server_ip.datatype="ip4addr"
    relay_server_ip.default='127.0.0.1'

relay_server_port = s:option(Value, "relay_server_port", translate("relay_server_port"),translate("Server Port (Required)"))
    relay_server_port.datatype="port"
    relay_server_port.default=11451

return m
