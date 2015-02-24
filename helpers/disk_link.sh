#!/bin/busybox ash

blkid_to_link()(
while read DEV AA BB CC DD
do
  export DEV="${DEV%:}"
  for I in $AA $BB $CC $DD
  do
    case $I in
      UUID*) I="${I#*=?}"
        cd /dev/disk/by-uuid && ln -sf "$DEV" "${I%?}"
	;;
      LABEL*) I="${I#*=?}"
        cd /dev/disk/by-label && ln -sf "$DEV" "${I%?}"
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

if test -b "/dev/$MDEV"
  then
    mkdir -p /dev/disk/by-uuid /dev/disk/by-label
    blkid /dev/$MDEV | blkid_to_link
  else
    mkdir -p /dev/disk/by-uuid /dev/disk/by-label || exit
    blkid | blkid_to_link
  fi

