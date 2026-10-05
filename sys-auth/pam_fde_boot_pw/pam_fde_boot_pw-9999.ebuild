# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson pam git-r3

DESCRIPTION="PAM module to transfer FDE boot passwords from kernel keyring to PAM session"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/pam_fde_boot_pw"
EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/pam_fde_boot_pw"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

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
