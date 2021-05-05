# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTORECONF=1

inherit autotools

DESCRIPTION="Library providing high performance logging, tracing, ipc, and poll"
HOMEPAGE="https://github.com/ClusterLabs/libqb"
SRC_URI="https://github.com/ClusterLabs/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="debug doc examples static-libs test"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	test? ( dev-libs/check )
	doc? ( app-doc/doxygen[dot] )"

DOCS=(README.markdown ChangeLog)

src_prepare() {
	default

	# Skip installation of text documents without value
	sed -e '/dist_doc_DATA/d' -i Makefile.am || die

	# Do not append version suffix "-yank"
	sed 's|1-yank|1|' -i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug)
}

src_compile() {
	default
	use doc && emake doxygen
}

src_install() {
	emake install DESTDIR="${D}"

	if use examples ; then
		docinto examples
		dodoc examples/*.c
	fi

	use doc && HTML_DOCS=("docs/html/.")
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
