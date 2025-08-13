# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )

inherit autotools multilib python-any-r1 git-r3

DESCRIPTION="Cluster Fencing Agents"
HOMEPAGE="https://github.com/ClusterLabs/fence-agents"
EGIT_REPO_URI="https://github.com/ClusterLabs/fence-agents.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libvirt"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/libxslt
	dev-libs/nss
	libvirt? ( app-emulation/libvirt )
	$(python_gen_any_dep '
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/suds-community[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable libvirt libvirt-plugin) \
		$(use_enable libvirt cpg-plugin) \
		--disable-libvirt-qmf-plugin \
		$(use_enable libvirt serial-plugin ) \
		--docdir=/usr/share/doc/${P} \
		--libdir=/usr/$(get_libdir) \
		--localstatedir=/var
}

src_install() {
	default
	# dont force /var/run creation on installation wrt #451798
	rm -rf "${ED}"/var/run || die
}


