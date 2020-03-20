# switch-lan-play for OpenWrt
Make you and your friends play games like in a LAN.

```
                     Internet
                        |
        ARP,IPv4        |             LAN Packets
Switch <------->  Router(lan-play)  <-------------> Server
                                          UDP
```

## Usage

The packages in this repository implement the ``switch-lan-play`` client on OpenWrt.

To play with your friends, you and your friends should run the ``switch-lan-play`` client connecting to the **same** server on your PC, and set static IP on your Switch.

## Building

### Step 1
To build switch-lan-play for OpenWrt, first add this feed to your ``feeds.conf`` in a fully set-up OpenWrt SDK [(read here on how to setup the OpenWrt SDK)](https://openwrt.org/docs/guide-developer/using_the_sdk):

```
src-git openwrt-switch-lan-play https://github.com/hurrian/openwrt-switch-lan-play.git

$ ./scripts/feeds update -a
$ ./scripts/feeds install -a
```

### Step 2
Enable building the packages.
```
make menuconfig

Network -> Lan-play -> switch-lan-play <*>
LuCI -> 3. Applications -> luci-app-switch-lan-play <*>
```

### Step 3
Build the packages.
```
make package/luci-app-switch-lan-play/compile
make package/switch-lan-play/compile
```

### Step 4
Install the packages to your router.
```
opkg install /tmp/switch-lan-play-*.ipk
opkg install /tmp/luci-app-switch-lan-play-*.ipk
```

## License
Package [luci-app-switch-lan-play](https://github.com/skylovebeauty/luci-app-switch-lan-play) (c) @skylovebeauty
Package [switch-lan-play](https://github.com/spacemeowx2/switch-lan-play) (c) spacemeowx2
