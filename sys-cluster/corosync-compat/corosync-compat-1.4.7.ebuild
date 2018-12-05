# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_TREE="bf8ff17"
MY_PN="corosync"

DESCRIPTION="Compatibility files for libcoroipcc in =sys-cluster/${MY_PN}-${PV}"
HOMEPAGE="http://www.corosync.org/"
SRC_URI="http://build.clusterlabs.org/corosync/releases/${MY_PN}-${PV}.tar.gz"

LICENSE="BSD-2 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~x86 ~x86-fbsd"

RDEPEND="!<sys-cluster/corosync-2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

S="${WORKDIR}/${MY_PN}-${MY_PN}-${MY_TREE}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	default
}

src_install() {
	insinto /usr/include/corosync
	doins ${S}/include/corosync/confdb.h
	doins ${S}/include/corosync/coroipcc.h
	doins ${S}/include/corosync/coroipc_types.h
	doins ${S}/include/corosync/list.h
	doins ${S}/include/corosync/mar_gen.h
	doins ${S}/include/corosync/swab.h

	exeinto /usr/$(get_libdir)
	doexe ${S}/lib/libconfdb.so.4.1.0
	dosym libconfdb.so.4.1.0 /usr/$(get_libdir)/libconfdb.so.4
	dosym libconfdb.so.4.1.0 /usr/$(get_libdir)/libconfdb.so
	doexe ${S}/lib/libcoroipcc.so.4.0.0
	dosym libcoroipcc.so.4.0.0 /usr/$(get_libdir)/libcoroipcc.so.4
	dosym libcoroipcc.so.4.0.0 /usr/$(get_libdir)/libcoroipcc.so

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${S}/pkgconfig/libconfdb.pc
	doins ${S}/pkgconfig/libcoroipcc.pc

#	dodir /usr/$(get_libdir)/pkgconfig
#	sed \
#		-e "s|@PREFIX@|/usr|" \
#		-e "s|@LIBDIR@|/usr/$(get_libdir)|" \
#		-e "s|@LIB@|coroipcc|" \
#		-e "s|@LIBVERSION@|${PV}|" \
#		"${S}/pkgconfig/libtemplate.pc.in" > "${ED}/usr/$(get_libdir)/pkgconfig/libcoroipcc.pc" || die

}
