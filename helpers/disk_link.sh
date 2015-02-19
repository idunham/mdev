#!/bin/busybox ash

blkid_to_link()(
while read DEV AA BB CC DD
do
  export DEV="${DEV%:}"
  for I in $AA $BB $CC $DD
  do
    case $I in
      UUID*) I="${I#*=?}"
        cd /dev/disk/by-uuid && ln -s "$DEV" "${I%?}"
	;;
      LABEL*) I="${I#*=?}"
        cd /dev/disk/by-label && ln -s "$DEV" "${I%?}"
	;;
    esac    
  done
done
)


if test "$ACTION" = "remove"
  then
    for L in /dev/disk/by-*/*
      do [ -L "$L" -a ! -e "$L" ] && unlink "$L" || true
      done
    exit
  fi

if test "$DEVTYPE" = "partition"
  then
    mkdir -p /dev/disk/by-uuid /dev/disk/by-label
    blkid /dev/$MDEV | blkid_to_link
  else
    test -e /dev/disk/.mdev && exit
    mkdir -p /dev/disk/by-uuid /dev/disk/by-label || exit
    touch /dev/disk/.mdev
    blkid | blkid_to_link
  fi

