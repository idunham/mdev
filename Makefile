# Install mdev for Debian.
# expects busybox

PREFIX	?=/usr
DOCDIR	?=${PREFIX}/share/doc
MANDIR	?=${PREFIX}/share/man
MKIRDDIR?=${PREFIX}/share/initramfs-tools


install:
	mkdir -p -m 0755 ${DESTDIR}/etc/init.d ${DESTDIR}/sbin
	mkdir -p -m 0755 ${DESTDIR}/lib/mdev
	mkdir -p -m 0755 ${DESTDIR}/lib/mdev
	install -m 0644 mdev.conf ${DESTDIR}/etc
	install -m 0755 mdev.init ${DESTDIR}/etc/init.d
	ln -fs /bin/busybox ${DESTDIR}/sbin/mdev
	ln -fs ${MANDIR}/man1/busybox.1.gz ${DESTDIR}${MANDIR}/man8/mdev.8.gz
	install -m 0755 hooks/mdev-top 			\
		${DESTDIR}${MKIRDDIR}/scripts/init-top/mdev
	install -m 0755 hooks/mdev-bottom 		\
		${DESTDIR}${MKIRDDIR}/scripts/init-bottom/mdev
	install -m 0755 hooks/mdev-hook 		\
		${DESTDIR}${MKIRDDIR}/hooks/mdev
	cp -Rp helpers/* ${DESTDIR}/lib/mdev

