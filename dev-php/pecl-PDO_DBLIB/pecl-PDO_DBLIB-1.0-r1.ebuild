# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="pdo_dblib"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3 "

inherit php-ext-pecl-r3

DESCRIPTION="PHP bindings for the Free TDS library"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND=">=dev-db/freetds-0.91"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/PDO_DBLIB-1.0-config.patch"
	"${FILESDIR}/PDO_DBLIB-1.0-compile.patch"
)

src_prepare() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
	done

	php-ext-source-r3_src_prepare
}

src_configure() {
	if { use amd64; }; then
			config+=" --with-libdir=/usr/lib64"
	fi
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		econf ${config}
	done
}
