# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="Adds support for Telegram to Pidgin, Adium, Finch and other Libpurple based messengers"
HOMEPAGE="https://github.com/majn/telegram-purple"

EGIT_REPO_URI="https://github.com/majn/telegram-purple"
KEYWORDS="~amd64"
case ${PV} in
	"1.3.0")
	EGIT_COMMIT="0340e4f14b2480782db4e5b9242103810227c522"
	;;
	*)
	EGIT_BRANCH="master"
	KEYWORDS="~*"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE="+libwebp"

DEPEND="
	sys-devel/gettext
	dev-libs/libgcrypt:0/20
	libwebp? ( media-libs/libwebp )
	net-im/pidgin
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable libwebp)
}
