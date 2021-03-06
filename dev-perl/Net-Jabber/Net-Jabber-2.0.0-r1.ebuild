# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=REATMON
MODULE_VERSION=2.0
inherit perl-module

DESCRIPTION="Jabber Perl library"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-perl/XML-Stream
	dev-perl/Net-XMPP
	dev-perl/Digest-SHA1"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-2.0-no-dot-inc.patch" )

SRC_TEST="do"
