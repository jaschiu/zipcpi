# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="An xdg-desktop-portal backend using terminal file managers"
HOMEPAGE="https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser"
SRC_URI="https://github.com/hunkyburrito/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="basu elogind man systemd"
REQUIRED_USE="^^ ( basu elogind systemd )"

DEPEND="
	dev-libs/inih
	basu?    ( dev-libs/basu )
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
	sys-apps/xdg-desktop-portal
"
BDEPEND="
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature systemd)
		-Dsd-bus-provider=$(usex systemd libsystemd $(usex elogind libelogind basu))
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc README.md Compatibility.md
}

pkg_postinst() {
	elog "Example configuration and wrapper scripts for various terminal file"
	elog "managers are installed to:"
	elog "  ${EROOT}/usr/share/xdg-desktop-portal-termfilechooser/"
	elog ""
	elog "Copy the example config to:"
	elog "  ~/.config/xdg-desktop-portal-termfilechooser/config"
	elog "and edit as needed."
}
