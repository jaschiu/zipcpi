# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools cmake xdg-utils

DESCRIPTION="Simple GTK+ v3 OTP client (TOTP and HOTP)"
HOMEPAGE="https://github.com/paolostivanin/OTPClient"
SRC_URI="https://github.com/paolostivanin/OTPClient/archive/v${PV}.zip -> ${P}.zip"
S="${WORKDIR}/OTPClient-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tray"
RESTRICT="mirror"

RDEPEND="
  >=x11-libs/gtk+-3.24:3
  >=dev-libs/glib-2.68.0:2
  >=dev-libs/jansson-2.12.0
  >=dev-libs/libgcrypt-1.10.1
  >=media-libs/libpng-1.6.30
  >=dev-libs/libcotp-3.0.0
  >=media-gfx/zbar-0.20
  >=media-gfx/qrencode-4.0.2
  tray? ( >=dev-libs/libayatana-appindicator-0.1 )
  >=app-crypt/libsecret-0.20
"

DEPEND="
  ${RDEPEND}
  >=dev-libs/protobuf-c-1.3.0
"

src_configure() {
  local mycmakeargs=(
    -DENABLE_MINIMIZE_TO_TRAY=$(usex tray)
  )
  cmake_src_configure
}

