# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools cmake gnome2-utils xdg-utils

DESCRIPTION="GTK4/libadwaita OTP client (TOTP and HOTP)"
HOMEPAGE="https://github.com/paolostivanin/OTPClient"
SRC_URI="https://github.com/paolostivanin/OTPClient/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OTPClient-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tray"
RESTRICT="mirror"

RDEPEND="
  >=dev-libs/glib-2.74:2
  >=dev-libs/jansson-2.13
  >=dev-libs/libgcrypt-1.10.1
  >=dev-libs/libcotp-4.0.0
  >=dev-libs/protobuf-c-1.3.0
  >=gui-libs/gtk-4.10:4
  >=gui-libs/libadwaita-1.5:1
  >=x11-libs/gdk-pixbuf-2.36.8:2
  >=media-gfx/zbar-0.20
  >=media-gfx/qrencode-4.0.2
  >=app-crypt/libsecret-0.20
  >=sys-apps/util-linux-2.34
"

DEPEND="
  ${RDEPEND}
"

src_configure() {
  local mycmakeargs=(
    -DENABLE_MINIMIZE_TO_TRAY=$(usex tray)
  )
  cmake_src_configure
}

src_install() {
  cmake_src_install

  # generated cache files, recreated by gnome2-utils in pkg_postinst
  rm -f "${ED}/usr/share/glib-2.0/schemas/gschemas.compiled" || die
  rm -f "${ED}/usr/share/icons/hicolor/icon-theme.cache" || die
}

pkg_postinst() {
  gnome2_schemas_update
  gnome2_icon_cache_update
}

pkg_postrm() {
  gnome2_schemas_update
  gnome2_icon_cache_update
}
