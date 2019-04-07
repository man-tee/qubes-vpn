# qubes-vpn

Turns an AppVM into a VPN AppVM that provides VPN connection to other qubes.

Some of the content here is based on the following Qubes OS doc:

https://www.qubes-os.org/doc/vpn/

You should make your own setup if you can. The Qubes OS-hosted doc page is solid
guide.

## List of features

1. Automatic establishment of VPN connection on AppVM boot.
2. GUI prompt for VPN server selection.
3. GUI prompt for VPN username (optional) and password.
4. Tray notification icon facilitating OpenVPN log display.

## Installation

**IMPORTANT:** If you need an automated/head-less VPN connection, this setup
won't do as it requires user responses via GUI. You may, if you wish, change the
`rc.config` file to pick a VPN at random and store credentials (if any) in the
AppVM itself. However, if your needs are such I'd suggest you make it yourself
as that's not what this project aims for.

### dom0

AppVM needs to have 'Provides network' switch on. To check (or change) issue:

``` shell
qvm-prefs [YOUR_VM_NAME] provides_network # to view the value
qvm-prefs [YOUR_VM_NAME] provides_network True # to set the value
```

I prefer to base such an AppVM on the latest Fedora minimal template. To obtain
one, issue:

``` shell
sudo qubes-dom0-update --action=reinstall qubes-template-fedora-[VERSION]
```

At the time of writing, the most recent `[VERSION]` is 29.

The list of sufficient packages can be found [here](./FEDORA-PACKAGES). I do not
claim it to be a minimal possible list.

If you wish to prune software that's not in the list above, issue:
``` shell
# Remove superflous packages
# Provided you get ARG_MAX issues, you might want to split the comm output to
# chunks.
dnf --noautoremove $(
        comm -13 \
                <(sort ./FEDORA-PACKAGES | uniq) \
                <(dnf list installed | tail -n +2 | awk '{print $1;}' | sort)
)

# To install the set above; the length is substantially smaller than common
# ARG_MAX values so you should be fine.
dnf install $(cat ./FEDORA-PACKAGES)
```

### Inside AppVM

The directory structure should be installed as is on your AppVM. Be careful not
to overwrite any existing custom `rc.local` or `qubes-firewall-user-script`
entries.

Add your openvpn `*.ovpn` config files to `/rw/config/vpn/config`. Provided you use
standard VPN setup (see below), no changes will be required. Startup script adds
these lines to your config:

```
redirect-gateway def1
script-security 2
up 'qubes-vpn-handler.sh up'
down 'qubes-vpn-handler.sh down'
```

Optionally, set username in `rc.local` by setting the `USERNAME` variable in
https://github.com/man-tee/qubes-vpn/blob/6ae85f893d7a05866e7f8ca2c4d3136be123ae61/rw/config/rc.local#L49
as follows:

``` shell
USERNAME="yourusername"
```

You will not be prompted for username later on. I leave it to your judgement whether
or not this is desirable.

### Different AppVMs

Just set the vpn you just setup as netvm for your AppVMs.

``` shell
qvm-prefs [SOME_VM] netvm [APP_VM_ABOVE]
```

Qubes OS infrastructure will make sure that the VPN AppVM boots prior to that AppVM.

## Usage

After the VPN AppVM starts, you're asked to select a server configuration to use,
(if not set) your username and your password. That's all. You may review OpenVPN
logs by right-clicking the newly created tray icon and then selecting that particular
option.

## Final Notes

From my experince it is quite sufficient to allocate 300-350MB worth of RAM to
the AppVM. I have found it a good habit to opt out of memory balancing to guarantee
that resources be available and no craziness occurs with baloons and OOM.

## Further Development

See GitHub issues.

## Licensing

Distributed under BSD3 license, see [LICENSE](./LICENSE).
