# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 flag-o-matic

DESCRIPTION="Detects DDC/CI devices on DDC I2C busses and creates corresponding devices."
HOMEPAGE="https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="$RDEPEND
sys-kernel/linux-headers
"

S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	local modlist=(
		ddcci=misc:ddcci
		ddcci-backlight=misc:ddcci-backlight
	)
	local modargs=( INCLUDEDIR=/usr/include CXXFLAGS="-stdinc" )
	linux-mod-r1_src_compile
}

