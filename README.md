# qubes-vpn

Some of the content here is based on the following Qubes OS doc:

https://www.qubes-os.org/doc/vpn/

## List of features

1. Automatic establishment of VPN connection on AppVM boot.
2. GUI prompt for VPN server selection.
3. GUI prompt for VPN username (optional) and password.
4. Tray notification icon facilitating OpenVPN log display.

## Installation

The directory structure should be installed as is on your AppVM.
The setup will try and find any `*.ovpn` files in your `/rw/config/vpn/config`.
These files will be offered to you during AppVM boot to select from; they require
no extra changes as the script will try and modify them (not in place) prior to
their use.

## Licensing

Distributed under BSD3 license, see [LICENSE](./LICENSE).
