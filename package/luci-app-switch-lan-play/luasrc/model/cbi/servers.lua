-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.


local m, s, server_host


m = Map("switchlanplay", "%s - %s" %{translate("Switch LAN Play"), translate("Servers Manage")})

s = m:section(TypedSection, "servers")
s.addremove = false
s.anonymous = true

server_host = s:option(Value, "server", translate("server"), translate("Server Host - IP address or domain name (Required)"))
    server_host.datatype="host"
    server_host.default="127.0.0.1"
    server_host.rmempty="false"

return m
