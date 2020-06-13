# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PHP_EXT_NAME="pdo_dblib"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3 php7-4 "
inherit php-ext-pecl-r3

DESCRIPTION="PHP bindings for the Free TDS library"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="
	>=dev-db/freetds-0.91:=[iodbc,mssql]
	php_targets_php5-6? ( dev-lang/php:5.6[pdo] )
	php_targets_php7-0? ( dev-lang/php:7.0[pdo] )
	php_targets_php7-1? ( dev-lang/php:7.1[pdo] )
	php_targets_php7-2? ( dev-lang/php:7.2[pdo] )
	php_targets_php7-3? ( dev-lang/php:7.3[pdo] )
	php_targets_php7-4? ( dev-lang/php:7.4[pdo] )
	"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply ${FILESDIR}/PDO_DBLIB-1.0-config.patch
	eapply ${FILESDIR}/PDO_DBLIB-1.0-compile.patch
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 || use php_targets_php7-4 ; then
		eapply ${FILESDIR}/PDO_DBLIB-1.0-php7.patch
	fi
	php-ext-source-r3_src_prepare
}

src_configure() {
	[[ ${ABI} == x32 ]] && config+=" --with-libdir=/usr/libx32"
	[[ ${ABI} == amd64 ]] && config+=" --with-libdir=/usr/lib64"
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		econf ${config}
	done
}
