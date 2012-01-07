# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit eutils

IUSE="ssl postgres mysql"

DESCRIPTION="A mail transfer agent that uses MySQL or PostgreSQL as its data store"
HOMEPAGE="http://www.dbmail.org/"
SRC_URI="http://www.dbmail.org/download/2.0/${P}.tar.gz" 

DEPEND="openssl"

RDEPEND="mysql? ( >=dev-db/mysql-4.0.12 )
		postgres? ( dev-db/postgresql )"

SLOT="0"
LICENSE="gpl-2"
KEYWORDS="x86 amd64 ~ppc ~sparc"

pkg_setup() { 
	
	enewgroup dbmail
	enewuser dbmail -1 /bin/bash /home/dbmail dbmail
	einfo "Creating /home/dbmail if it does not exist."
	if ! [ -d /home/dbmail ]; then
		einfo "* Creating /home/dbmail"
		mkdir /home/dbmail
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/dbmail-startup-gentoo.patch
	epatch ${FILESDIR}/dbmail-2.0.4-fPIC.patch
}

src_compile() {
	if [ -n "`use mysql`" -a -n "`use postgres`" ]; then
		eerror "Unfortunatly you can't have both MySQL and PostgreSQL enabled at the same time."
		eerror "You have to remove either 'mysql' or 'postgres' from your USE flags before emerging this."

		has_version ">=sys-apps/portage-2.0.50" && (
			einfo "You can add:"
			einfo "net-mail/dbmail [use flags]"
			einfo "to the file:"
			einfo "/etc/portage/package.use"
			einfo "to permamently set this package's USE flags"
		)

		exit 1
	fi

	local myconf

	use mysql && myconf="$myconf --with-mysql"
	use postgres && myconf="$myconf --with-pgsql"

	cd ${S}
	./configure --prefix=/usr \
		--with-openssl \
		$myconf || die

	emake || die "compile problem"

}

src_install() {
	cd ${S}
	make DESTDIR=${D} install || die "Install Problem"

	dodoc AUTHORS BUGS INSTALL EXTRAS ChangeLog COPYING \
		INSTALL.exim INSTALL.postfix INSTALL.qmail UPGRADING \
		VERSION NEWS README THANKS TODO
	insinto /etc
	doins dbmail.conf
	
	insinto /etc/conf.d
	doins contrib/startup-scripts/gentoo/conf.d/dbmail-imapd
	doins contrib/startup-scripts/gentoo/conf.d/dbmail-lmtpd
	doins contrib/startup-scripts/gentoo/conf.d/dbmail-pop3d
	
	exeinto /etc/init.d
	newexe contrib/startup-scripts/gentoo/init.d/dbmail-pop3d dbmail-pop3d
	newexe contrib/startup-scripts/gentoo/init.d/dbmail-lmtpd dbmail-lmtpd
	newexe contrib/startup-scripts/gentoo/init.d/dbmail-imapd dbmail-imapd

	dobin contrib/mailbox2dbmail/mailbox2dbmail
	doman contrib/mailbox2dbmail/mailbox2dbmail.1

	mkdir -p ${D}/home/dbmail/sql
	cp -a sql ${D}/home/dbmail/
	
}

pkg_postinst() {
	install -d -m0755 -o dbmail -g dbmail ${ROOT}/var/run/dbmail

	einfo ">>> Execute the following command"
	einfo ">>> ebuild  /var/db/pkg/net-mail/${PF}/${PF}.ebuild config"
	einfo ">>> to setup the initial database environment and "
	einfo ">>> for more setup instructions."
	einfo ">>> Database schemes can be found in /home/dbmail/sql"
	einfo ">>> --- For maintenance ---"
	einfo ">>> add this to crontab: 0 3 * * * /usr/bin/dbmail-util -cpdy >> /dev/null 2>&1 "
}

pkg_config() {

	einfo ">>> Initializing the database user, databse, and tables ..."
	if [  -n "`use postgres`" ]; then	
		einfo ">>> Creating postgres user dbmail. "
		einfo "You may want to add a password for dbmail: "
		einfo "`psql -c "ALTER USER dbmail WITH PASSWORD 'secret';"`"
		createuser -U postgres -a -d dbmail
		einfo ">>> Creating postgres database dbmail. "
		createdb dbmail
		psql -U dbmail dbmail < /home/dbmail/sql/postgresql/create_tables.pgsql
	else 
		einfo ">>> Creating mysql database dbmail. "
		mysqladmin create dbmail
		mysql dbmail < /home/dbmail/sql/mysql/create_tables.mysql
		einfo "You may want to add a user for dbmail database "
	fi
	einfo "Please read /usr/share/doc/${P}/INSTALL.gz"
	einfo "for remaining instructions on setting up dbmail users and "
	einfo "for finishing configuration to connect to your MTA and "
	einfo "to connect to your db."
	einfo ""
	einfo "The next step is to add users to the db. Example: "
	einfo "  ./dbmail-users -a john -w secret -g 0 -m 25M "
	einfo "           -s john@dude.org john@dude.net @net.com"
	einfo "You will also want to follow the installation instructions "
	einfo "on setting up the maintenance program to delete old messages."
	einfo "Don't forget to edit /etc/dbmail.conf as well. :)"
}
