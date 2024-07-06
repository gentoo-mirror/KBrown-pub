# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

XORG_DRI="always"
XORG_EAUTORECONF="yes"
XORG_CONFIGURE_OPTIONS="--with-drmmode=exynos --disable-selective-werror"
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools xorg-3 

MY_PR="1endless9"
MY_PV="v${PV}-${MY_PR}"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/mdrjr/xf86-video-armsoc/archive/v${PV}-${MY_PR}.tar.gz -> ${P}-${PR}.tar.gz"
	KEYWORDS="~arm ~arm64"
	S="${WORKDIR}/${P}-${MY_PR}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mdrjr/xf86-video-armsoc.git
		git@github.com:mdrjr/xf86-video-armsoc.git"
	## release branch for github tarballs: r4p0-umplock
	## alternate 5422 branch is more active: 5422_r5p1
	EGIT_BRANCH="5422_r5p1"
fi

DESCRIPTION="Open-source X.org graphics driver for ARM graphics"
HOMEPAGE="https://github.com/mdrjr/xf86-video-armsoc"
LICENSE="MIT"

RDEPEND=">=x11-base/xorg-server-1.9
	!x11-drivers/mali-drivers"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libump"

# Best way to jam this into the config parameter?
#IUSE="exynos pl111"

AUTOTOOLS_IN_SOURCE_BUILD="yes"
AUTOTOOLS_AUTORECONF="yes"

