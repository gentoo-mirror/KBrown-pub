# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO: figure out htf to make python.eclass work

EAPI="8"

inherit multilib
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.code.sf.net/p/urjtag/git"
	inherit git-r3 autotools
	S=${WORKDIR}/${P}/${PN}
else
	SRC_URI="mirror://sourceforge/urjtag/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

DESCRIPTION="Tool for communicating over JTAG with flash chips, CPUs, and many more"
HOMEPAGE="http://urjtag.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="ftd2xx ftdi readline usb"

DEPEND="ftdi? ( dev-embedded/libftdi )
	ftd2xx? ( dev-embedded/libftd2xx )
	readline? ( sys-libs/readline:= )
	usb? ( virtual/libusb:0 )"
RDEPEND="${DEPEND}
	!dev-embedded/jtag"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		mkdir -p m4
		eautopoint
		eautoreconf
	fi
	default
}

src_configure() {
	use readline || export vl_cv_lib_readline=no

	econf \
		--disable-werror \
		--disable-python \
		$(use_with ftd2xx ftd2xx) \
		$(use_with ftdi libftdi) \
		$(use_with usb libusb)
}

src_install() {
	default
	prune_libtool_files
}
