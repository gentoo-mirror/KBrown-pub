# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Load test and measure performance on HTTP/FTP services and databases."
HOMEPAGE="https://jmeter.apache.org/"
#SRC_URI="https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${PV}.tgz"
SRC_URI="https://downloads.apache.org/jmeter/binaries/apache-jmeter-${PV}.tgz"
LICENSE="Apache-2.0"

SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/apache-jmeter-${PV}/"

src_prepare() {
	cd "${S}/bin/"
	rm -f *.bat *.cmd
}

src_install() {
	dodir /opt/${PN}
	cp -aR * "${D}/opt/${PN}/"
	use doc || rm -fR "${D}/opt/${PN}/docs"
	dobin "${FILESDIR}/jmeter"
	chmod 755 "${D}/usr/bin/jmeter"
}
