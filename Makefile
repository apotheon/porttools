# FreeBSD Port Tools
#
# Makefile
# 
# $Id: Makefile,v 1.24 2009/09/09 19:58:30 skolobov Exp $
# 

# Package name and version
PORTNAME?=	porttools
PORTVERSION?=	0.99
DISTNAME?=	${PORTNAME}-${PORTVERSION}
.if defined(PORTREVISION) && defined(PORTEPOCH)
VERSIONSTRING=	${PORTVERSION}_${PORTREVISION},${PORTEPOCH}
.elif defined(PORTREVISION)
VERSIONSTRING=	${PORTVERSION}_${PORTREVISION}
.elif defined(PORTEPOCH)
VERSIONSTRING=	${PORTVERSION},${PORTEPOCH}
.else
VERSIONSTRING=	${PORTVERSION}
.endif

PROGRAMS=	port
SCRIPTS=	cmd_commit cmd_create cmd_diff cmd_fetch cmd_getpr cmd_help \
	 	cmd_install cmd_submit cmd_test cmd_upgrade util_diff
DOCS=		LICENSE NEWS README THANKS
MAN1=		port.1 
MAN5=		porttools.5 

# Normally provided via bsd.port.mk infrastructure
PREFIX?=	/pkg
DATADIR?=	${PREFIX}/share/${PORTNAME}
DOCSDIR?=	${PREFIX}/share/doc/${PORTNAME}

BSD_INSTALL_SCRIPT?=	install -m 555
BSD_INSTALL_DATA?=	install -m 444
BSD_INSTALL_MAN?=	install -m 444

# Targets
all: ${PROGRAMS} ${SCRIPTS} Makefile

.SUFFIXES: .in

.in:
	sed -e 's%__VERSION__%${VERSIONSTRING}%;s,__PREFIX__,${PREFIX},' \
		inc_header.in ${.IMPSRC} > ${.TARGET}
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
	rm -rf ${PROGRAMS} ${SCRIPTS} ${DISTNAME}*

##
## Maintainer section
##
distfile: ${DISTNAME}.tar.gz
	cp ${DISTNAME}.tar.gz /FreeBSD/distfiles
	
release: ${DISTNAME}.tar.gz Makefile
	sfupload ${DISTNAME}.tar.gz
	rm -f ${DISTNAME}.tar.gz

${DISTNAME}.tar.gz: ${PROGRAMS} ${SCRIPTS} Makefile
	rm -rf ${DISTNAME}
	mkdir ${DISTNAME}
	cp Makefile *.in ${DOCS} ${MAN1} ${MAN5} .todo ${DISTNAME}
	tar cvzf ${DISTNAME}.tar.gz ${DISTNAME}
	rm -rf ${DISTNAME}

TODO: .todo Makefile
	devtodo --filter -done,+children --TODO
