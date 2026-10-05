# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson pam

DESCRIPTION="PAM module to transfer FDE boot passwords from kernel keyring to PAM session"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/pam_fde_boot_pw"
SRC_URI="https://git.sr.ht/~kennylevinsen/pam_fde_boot_pw/archive/49bf498fd8d13f73e4a24221818a8a5d2af20088.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-49bf498fd8d13f73e4a24221818a8a5d2af20088"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-apps/keyutils:=
	sys-libs/pam
"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-Dpam-mod-dir="$(getpam_mod_dir)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
