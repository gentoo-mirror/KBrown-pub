# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit git-r3

DESCRIPTION="Adds support for Telegram to Pidgin and Finch."
HOMEPAGE="https://github.com/majn/telegram-purple"

EGIT_REPO_URI="https://github.com/majn/telegram-purple"
KEYWORDS="~amd64"
case ${PV} in
	"1.3.1")
	EGIT_COMMIT="065e0b7ac946f65f080bf05e8f91a1a4214e2d24"
	;;
	"1.4.1")
	EGIT_COMMIT="d3d090917df22876fad6088ab53c4c914bee2acf"
	;;
	"1.4.2")
	EGIT_COMMIT="53d5ee50c2d486e9ca21a8b126115efdc65a5b15"
	;;
	"1.4.3")
	EGIT_COMMIT="ca42dcf0e6bebe2d0f818e1221db9518561dd8a0"
	;;
	"1.4.4")
	EGIT_COMMIT="1703eb8a6b85acb388078cd829717195db36fbad"
	;;
	"1.4.5")
	EGIT_COMMIT="3946f7e9482dd648c27c1605776d13cb23e54f35"
	;;
	"1.4.6")
	EGIT_COMMIT="9bd539014635e6354ac6eae6e8e65dcef1365baf"
	;;
	"1.4.7")
	EGIT_COMMIT="7d1d61be591d181295e470b38f508867bbf0efa9"
	;;
	*)
	EGIT_BRANCH="master"
	KEYWORDS="~*"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE="+webp"

DEPEND="
	sys-devel/gettext
	dev-libs/libgcrypt:0/20
	webp? ( media-libs/libwebp )
	net-im/pidgin
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable webp libwebp)
	sed -i -e 's:-Werror::' tgl/Makefile.in || die
}
