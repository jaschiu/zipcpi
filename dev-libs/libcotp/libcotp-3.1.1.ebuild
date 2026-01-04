# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

DESCRIPTION="C library that generates TOTP and HOTP"
HOMEPAGE="https://github.com/paolostivanin/libcotp"
SRC_URI="https://github.com/paolostivanin/libcotp/archive/v${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
  || ( >=dev-libs/libgcrypt-1.8.0 >=dev-libs/openssl-3.0.0 >=net-libs/mbedtls-3.6.4 )
"

DEPEND="
  ${RDEPEND}
"

