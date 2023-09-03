# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="8"

PHP_EXT_NAME="ffmpeg"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP=" php5-6 "

inherit php-ext-source-r3 

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension that provides access to movie info"
HOMEPAGE="https://sourceforge.net/projects/ffmpeg-php/"
SRC_URI="mirror://sourceforge/ffmpeg-php/${P}.tbz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="libav"

DEPEND="libav? ( media-video/libav:0= )
	!libav? ( media-video/ffmpeg:0= )
	dev-lang/php:*[gd]"
RDEPEND="${DEPEND}"

# The test breaks with the test movie, but it the same code works fine with
# other movies

RESTRICT="test"

DOCS="CREDITS ChangeLog EXPERIMENTAL TODO"

PATCHES="${FILESDIR}/${P}-avutil50.patch
		${FILESDIR}/${P}-ffmpeg.patch
		${FILESDIR}/${P}-ffmpeg-4.patch
		${FILESDIR}/${P}-log.patch
		${FILESDIR}/${P}-php5-4.patch
		${FILESDIR}/${P}-ffincludes.patch
		${FILESDIR}/${P}-ffmpeg1.patch
		${FILESDIR}/${P}-api.patch
		${FILESDIR}/${P}-libav10.patch"

src_prepare() {
	[[ ${ABI} == x32 ]] && sed -i 's/lib64/libx32/' config.m4
	php-ext-source-r3_src_prepare
}
