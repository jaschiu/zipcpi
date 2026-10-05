# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AI software engineering agent that lives in your terminal (prebuilt binary)"
HOMEPAGE="https://devin.ai"

# Upstream publishes versioned per-platform tarballs.  The install script at
# https://cli.devin.ai/install.sh resolves them via
# https://static.devin.ai/cli/current/manifest.json; the musl entries there
# point at the same static gnu tarballs.
SRC_URI="
	amd64? ( https://static.devin.ai/cli/${PV}/devin-${PV}-x86_64-unknown-linux.tar.gz )
	arm64? ( https://static.devin.ai/cli/${PV}/devin-${PV}-aarch64-unknown-linux.tar.gz )
"
S="${WORKDIR}"

# Proprietary; no license text is shipped in the tarball.
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="bindist mirror strip"

# The binary is a fully static PIE using rustls with bundled webpki roots;
# it only execs git for repository operations.
RDEPEND="dev-vcs/git"

QA_PREBUILT="opt/devin-cli/*"

src_install() {
	local apphome="/opt/devin-cli"

	doman share/man/man1/*.1
	rm -r share/man || die

	# Keep upstream's version-dir layout (bin/ and share/ as siblings) so the
	# binary can resolve its bundled docs relative to its real path.
	insinto "${apphome}"
	doins -r bin share

	fperms +x "${apphome}/bin/devin"
	dosym -r "${apphome}/bin/devin" "/usr/bin/devin"

	# Deliberately install no `distribution` marker file: without one
	# `devin update` reports auto-update unavailable, leaving upgrades
	# to Portage.
}

pkg_postinst() {
	elog "Run 'devin' to start a session, or 'devin setup' for the first-run"
	elog "wizard (authentication, git provider integration)."
	elog
	elog "This package is managed by Portage; 'devin update' is disabled."
	elog "New versions will arrive via ebuild bumps."
}
