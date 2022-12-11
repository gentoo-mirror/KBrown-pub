# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for silc server"
ACCT_USER_ID=526
ACCT_USER_GROUPS=( silcd )

acct-user_add_deps
