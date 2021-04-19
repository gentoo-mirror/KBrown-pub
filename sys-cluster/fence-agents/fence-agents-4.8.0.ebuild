# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit multilib python-any-r1  git-r3

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="Cluster Fencing Agents"
HOMEPAGE="https://github.com/ClusterLabs/fence-agents"
EGIT_REPO_URI="https://github.com/ClusterLabs/fence-agents.git"
EGIT_COMMIT="v4.8.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

#RDEPEND="~sys-cluster/libccs-${PV}"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-libs/libxslt
	$(python_gen_any_dep '
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/suds[${PYTHON_USEDEP}]
	')"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${P} \
		--libdir=/usr/$(get_libdir) \
		--localstatedir=/var
}

src_install() {
	default
	# dont force /var/run creation on installation wrt #451798
	rm -rf "${ED}"/var/run || die
}

pkg_postinst() {
	if [[ "${EROOT}" != "/" ]] ; then
		ewarn "You have to run 'ccs_update_schema' in the chroot-environment"
		ewarn "to update the schema file for the cluster configuration."
		ewarn "Otherwise you will not be able to define ressources."
	else
		elog "Running ccs_update_schema to update the configuration file schema"
		ccs_update_schema -v -f
	fi
}

pkg_postrm() {
	if [[ "${EROOT}" != "/" ]] ; then
		ewarn "You have to run 'ccs_update_schema' in the chroot-environment"
		ewarn "to update the schema file for the cluster configuration."
		ewarn "Otherwise you may be able to define ressources even though they"
		ewarn "are not present anymore."
	else
		elog "Running ccs_update_schema to update the configuration file schema"
		ccs_update_schema -v -f
	fi
}
