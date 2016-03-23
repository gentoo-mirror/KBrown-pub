# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A skeleton, statically managed /dev"
HOMEPAGE="https://bugs.gentoo.org/107875"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="sys-apps/makedev"
DEPEND="${RDEPEND}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} == "buildonly" ]] ; then
		# User is just compiling which is fine -- all our checks are merge-time.
		return
	fi

}

pkg_postinst() {
	MAKEDEV -d "${ROOT}"/dev generic sg scd rtc hde hdf hdg hdh input audio video
}
