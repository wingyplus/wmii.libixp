# libixp - simple 9P client-/server-library
#   (C)opyright MMIV-MMVI Anselm R. Garbe

include config.mk

SRC = client.c convert.c intmap.c message.c request.c server.c socket.c \
      transport.c util.c
SRCIXPC = ixpc.c
OBJ = ${SRC:.c=.o}
OBJIXPC = ${SRCIXPC:.c=.o}

all: options libixp.a ixpc

options:
	@echo libixp build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"
	@echo "LD       = ${LD}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.mk ixp.h

libixp.a: ${OBJ}
	@echo AR $@
	@${AR} $@ ${OBJ}
	@${RANLIB} $@

ixpc: ${OBJIXPC}
	@echo LD $@
	@${LD} -o $@ ${OBJIXPC} ${LDFLAGS} -lixp
	@strip $@

clean:
	@echo cleaning
	@rm -f ixpc libixp.a ${OBJ} ${OBJIXPC} libixp-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p libixp-${VERSION}
	@cp -R LICENSE LICENSE.p9p Makefile README config.mk ixp.h ${SRC} ${SRCIXPC} libixp-${VERSION}
	@tar -cf libixp-${VERSION}.tar libixp-${VERSION}
	@gzip libixp-${VERSION}.tar
	@rm -rf libixp-${VERSION}

install: all
	@echo installing header to ${DESTDIR}${PREFIX}/include
	@mkdir -p ${DESTDIR}${PREFIX}/include
	@cp -f ixp.h ${DESTDIR}${PREFIX}/include
	@chmod 644 ${DESTDIR}${PREFIX}/include/ixp.h
	@echo installing library to ${DESTDIR}${PREFIX}/lib
	@mkdir -p ${DESTDIR}${PREFIX}/lib
	@cp -f libixp.a ${DESTDIR}${PREFIX}/lib
	@chmod 644 ${DESTDIR}${PREFIX}/lib/libixp.a
	@echo installing ixpc to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ixpc ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/ixpc

uninstall:
	@echo removing header file from ${DESTDIR}${PREFIX}/include
	@rm -f ${DESTDIR}${PREFIX}/include/ixp.h
	@echo removing library file from ${DESTDIR}${PREFIX}/lib
	@rm -f ${DESTDIR}${PREFIX}/lib/libixp.a
	@echo removing ipx client from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/ixpc

.PHONY: all options clean dist install uninstall