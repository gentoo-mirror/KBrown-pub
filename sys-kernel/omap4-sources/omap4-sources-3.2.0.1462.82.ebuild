# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

ETYPE="sources"

inherit kernel-2 
detect_version

MY_PV="$(ver_cut 1-3)-$(ver_cut 4-5)"


DESCRIPTION="OMAP4 sources"
HOMEPAGE=""
SRC_URI="http://ports.ubuntu.com/ubuntu-ports/pool/main/l/linux-ti-omap4/linux-ti-omap4_${MY_PV}.tar.gz"

KEYWORDS="arm"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	mv ubuntu-precise linux-${PV}-omap4

}

src_install() {
	insinto /usr/src/
	doins -r linux-${PV}-omap4
}
