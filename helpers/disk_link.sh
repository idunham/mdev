#!/bin/busybox ash

blkid_to_link()(
IFS='"'
unset SUBDIR
while read A B C D E F G H I J
do
  IFS=
  for ENT in "$A" "$B" "$C" "$D" "$E" "$F" "$G" "$H" "$I" "$J"
  do
    if [ -z "$SUBDIR" ]
    then
      case "$ENT" in
        *PARTUUID=)
        ;;
        *UUID=)
          SUBDIR="by-uuid"
	;;
        *LABEL=)
          SUBDIR="by-label"
	;;
      esac
    else
# Try to sanitize the label.
      ENT=$(echo "$ENT" | sed -e 's:/:\\x2f:g;s:\$:\\x24:g;s:\":\\x22:g' \
            -e 's:\ :\\x20:g;s:\;:\\x3b:g;s:`:\\x60:g')
#      ENT="${ENT/\//\\x2f}"
#      ENT="${ENT/\$/\\x24}"
#      ENT="${ENT/\"/\\x22}"
#      ENT="${ENT/\ /\\x20}"
#      ENT="${ENT/\`/\\x60}"
      ln -sf "../../$MDEV" /dev/disk/"$SUBDIR"/"$ENT"
      unset SUBDIR
    fi
  done
  IFS='"'
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

