# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRCDIR = src

SRC = ${SRCDIR}/drw.c ${SRCDIR}/dwm.c ${SRCDIR}/util.c
OBJ = ${patsubst ${SRCDIR}/%.c,%.o,${SRC}}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

%.o: ${SRCDIR}/%.c
	${CC} -c ${CFLAGS} $<

${OBJ}: ${SRCDIR}/config.h config.mk

${SRCDIR}/config.h:
	cp ${SRCDIR}/config.def.h $@

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README.md ${SRCDIR} config.mk dwm.1 dwm.png \
		dwm.desktop dwm-${VERSION}
	rm dwm-${VERSION}/${SRCDIR}/config.h
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	# bin
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	# man
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	# xsession
	mkdir -p ${DESTDIR}/usr/share/xsessions
	cp -f dwm.desktop ${DESTDIR}/usr/share/xsessions
	chmod 644 ${DESTDIR}/usr/share/xsessions/dwm.desktop

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm ${DESTDIR}${MANPREFIX}/man1/dwm.1 \
		${DESTDIR}/usr/share/xsessions/dwm.desktop

.PHONY: all options clean dist install uninstall
