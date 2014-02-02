# FreeBSD Port Tools
#
# Makefile
# 
# $Id: Makefile,v 1.24 2009/09/09 19:58:30 skolobov Exp $
# 

# Package name and version
PORTNAME?=	porttools
PORTVERSION?=	1.00.2014.02.02
DISTNAME?=	${PORTNAME}-${PORTVERSION}
VERSIONSTRING=	${PORTVERSION}

PROGRAMS=	scripts/port
SCRIPTS=	scripts/cmd_commit scripts/cmd_create scripts/cmd_diff scripts/cmd_fetch scripts/cmd_getpr scripts/cmd_help \
		scripts/cmd_install scripts/cmd_submit scripts/cmd_test scripts/cmd_upgrade scripts/util_diff
DOCS=		LICENSE NEWS README THANKS
MAN1=		man/port.1
MAN5=		man/porttools.5

# Normally provided via bsd.port.mk infrastructure
PREFIX?=	~/pkg
DATADIR?=	${PREFIX}/share/${PORTNAME}
DOCSDIR?=	${PREFIX}/share/doc/${PORTNAME}
MANPREFIX?= ${PREFIX}/share

BSD_INSTALL_SCRIPT?=	install -m 555
BSD_INSTALL_DATA?=	install -m 444
BSD_INSTALL_MAN?=	install -m 444

# Targets
all: ${PROGRAMS} ${SCRIPTS} Makefile

.SUFFIXES: .in

.in:
	sed -e 's%__VERSION__%${VERSIONSTRING}%;s,__PREFIX__,${PREFIX},' \
		scripts/inc_header.in ${.IMPSRC} > ${.TARGET}
	chmod a+x ${.TARGET}

install: ${PROGRAMS} ${SCRIPTS}
	${BSD_INSTALL_SCRIPT} ${PROGRAMS} ${DESTDIR}${PREFIX}/bin
	mkdir -p ${DESTDIR}${DATADIR}
	${BSD_INSTALL_SCRIPT} ${SCRIPTS} ${DESTDIR}${DATADIR}
	mkdir -p ${DESTDIR}${MANPREFIX}/man/man1
	${BSD_INSTALL_MAN} ${MAN1} ${DESTDIR}${MANPREFIX}/man/man1
	mkdir -p ${DESTDIR}${MANPREFIX}/man/man5
	${BSD_INSTALL_MAN} ${MAN5} ${DESTDIR}${MANPREFIX}/man/man5

install-docs:
	mkdir -p ${DESTDIR}${DOCSDIR}
	${BSD_INSTALL_DATA} ${DOCS} ${DESTDIR}${DOCSDIR}

clean:
	rm -rf ${PROGRAMS} ${SCRIPTS}

TODO: .todo Makefile
	devtodo --filter -done,+children --TODO
