# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils xdg

DESCRIPTION="The break time reminder app (prebuilt Electron bundle)"
HOMEPAGE="
	https://hovancik.net/stretchly
	https://github.com/hovancik/stretchly
"

# Upstream ships a ready-to-run electron-builder linux tar.xz that bundles
# Electron itself, so this is a -bin ebuild installed under /opt.  See
# https://wiki.gentoo.org/wiki/Project:Chromium/Packaging_Electron_apps
SRC_URI="
	amd64? ( https://github.com/hovancik/stretchly/releases/download/v${PV}/Stretchly-${PV}.tar.xz )
	arm64? ( https://github.com/hovancik/stretchly/releases/download/v${PV}/Stretchly-${PV}-arm64.tar.xz )
"
S="${WORKDIR}"

# Stretchly itself is BSD-2-Clause (see upstream package.json).  Bundled
# Electron / Chromium / Node components carry their own licenses but are
# redistributed under terms compatible with BSD-2 for unmodified binaries.
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="bindist mirror strip splitdebug test"

# Empirically derived from objdump -p of the bundled stretchly binary and the
# native node addon node-desktop-idle-v2's prebuilt .node, plus dlopen()ed
# libraries (libnotify for notifications, libglvnd for GL).  The single
# minimum-version constraint is the Chromium 120+ ATK ABI floor.
RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/libglvnd
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-process/procps
	virtual/libudev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libnotify
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="opt/stretchly/*"

src_install() {
	local apphome="/opt/${PN%-bin}"

	# The amd64 tarball unpacks to Stretchly-${PV}/, the arm64 tarball to
	# Stretchly-${PV}-arm64/.  Locate whichever is present.
	local appdir
	appdir=$(echo "${WORKDIR}"/Stretchly-${PV}*) || die
	[[ -d ${appdir} ]] || die "unexpected upstream tarball layout: ${appdir}"
	cd "${appdir}" || die

	# Drop bits that are unused on Linux (Windows-only native modules ship in
	# the asar.unpacked tree and would otherwise be flagged by QA).
	local -a toremove=(
		LICENSE.electron.txt
		LICENSES.chromium.html
		resources/app.asar.unpacked/node_modules/windows-focus-assist
	)
	rm -rf "${toremove[@]}" || die

	# Drop prebuilt .node addons for non-linux arches; leave the linux-*
	# directory's full ABI matrix intact so the runtime picks the right one.
	local idle_pre="resources/app.asar.unpacked/node_modules/node-desktop-idle-v2/prebuilds"
	if [[ -d ${idle_pre} ]] ; then
		rm -rf "${idle_pre}"/win32-* "${idle_pre}"/darwin-* || die
	fi

	insinto "${apphome}"
	doins -r .

	fperms +x "${apphome}/stretchly"
	fperms +x "${apphome}/chrome_crashpad_handler"
	# chrome-sandbox needs SUID for namespace sandbox on kernels without
	# CONFIG_USER_NS; install it executable but not setuid-root (Gentoo
	# convention is to leave SUID-root binaries opt-in).
	fperms +x "${apphome}/chrome-sandbox"

	dosym -r "${apphome}/stretchly" "/usr/bin/${PN%-bin}"

	# Prebuilt electron binaries ship without BIND_NOW; mark them MPROTECT-
	# exempt so PaX-enabled kernels (hardened) don't kill the process.
	pax-mark m "${ED}${apphome}/stretchly"

	newicon -s 128 "${FILESDIR}/stretchly.png" stretchly.png
	domenu "${FILESDIR}/${PN}.desktop"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "Stretchly has been installed under /opt/stretchly with its bundled"
	elog "Electron runtime.  Launch via the desktop entry or 'stretchly'."
	elog
	elog "If breaks fail to start automatically based on idle time, ensure"
	elog "your user can read /dev/input/event* (typically the 'input' group"
	elog "or systemd-logind seat ACLs)."
}
