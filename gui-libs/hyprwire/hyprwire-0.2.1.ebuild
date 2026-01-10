# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A fast and consistent wire protocol for IPC"
HOMEPAGE="https://github.com/hyprwm/hyprwire"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/archive/refs/tags/v${PV}/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${PV}"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RESTRICT="!test? ( test )"
DEPEND="
	dev-libs/libffi
	>=gui-libs/hyprutils-0.9.0
"
RDEPEND="${DEPEND}"

src_configure() {
    local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
    )
    cmake_src_configure
}
