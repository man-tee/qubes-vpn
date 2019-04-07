#!/usr/bin/env bash

set -e

export PATH="$PATH:/usr/bin:/sbin"

case "$1" in
up)
        if test -z "$vpn_dns"
        then
                for optionname in ${!foreign_option_*}
                do
                        option="${!optionname}"
                        unset fops; fops=($option)
                        if test ${fops[1]} == "DNS"
                        then
                                vpn_dns="$vpn_dns ${fops[2]}"
                        fi
                done
        fi

        iptables -t nat -F PR-QBS

        if test -n "$vpn_dns"
        then
                for addr in $vpn_dns
                do
                        iptables -t nat -A PR-QBS -i vif+ \
                                 -p udp --dport 53 -j DNAT --to $addr
                        iptables -t nat -A PR-QBS -i vif+ \
                                 -p tcp --dport 53 -j DNAT --to $addr
                done

                msg="$(hostname): LINK IS UP."
                icon="network-idle"
        else
                msg="$(hostname): LINK UP, NO DNS"
                icon="dialog-error"
        fi

        su - -c "notify-send '$msg' --icon=$icon" user
        ;;
down)
        msg="$(hostname): LINK IS DOWN"
        icon="dialog-error"
        su - -c "notify-send '$msg' --icon=$icon" user
        ;;
esac
