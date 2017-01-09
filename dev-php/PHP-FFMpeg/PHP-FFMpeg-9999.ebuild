# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 

DESCRIPTION="An Object Oriented library to convert video/audio files with FFmpeg / AVConv."
HOMEPAGE="https://github.com/PHP-FFMpeg/PHP-FFMpeg"
EGIT_REPO_URI="https://github.com/PHP-FFMpeg/PHP-FFMpeg.git"
#EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/php:*
		media-video/ffmpeg
		dev-php/fedora-autoloader"
RDEPEND="${DEPEND}"

#src_unpack() {
#	git-r3_src_unpack
#	php-ext-source-r3_src_unpack
#}
#
#src_prepare() {
#	php-ext-source-r3_src_prepare
#}

S="${WORKDIR}/${PF}/src"
src_install() {
	insinto "/usr/share/php/FFMpeg"
	doins -r FFMpeg/. "${FILESDIR}"/autoload.php
	dodoc "${WORKDIR}/${PF}"/README.md
}

