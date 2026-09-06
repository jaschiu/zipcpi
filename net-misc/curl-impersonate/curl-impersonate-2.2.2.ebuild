# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib

DESCRIPTION="An active fork of curl-impersonate with more versions and build targets."
HOMEPAGE="https://github.com/lexiforest/curl-impersonate"

ZLIB_V="1.3.1"
ZSTD_V="1.5.7"
BROTLI_V="1.2.0"
BORINGSSL_SHA="156c7b75ae9b8c3b3f847acf264f17594c3859fb"
NGHTTP2_V="1.63.0"
NGTCP2_V="1.20.0"
NGHTTP3_V="1.15.0"
CURL_V="curl-8_21_0"

SRC_URI="https://github.com/lexiforest/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/madler/zlib/releases/download/v${ZLIB_V}/zlib-${ZLIB_V}.tar.gz
	https://github.com/facebook/zstd/releases/download/v${ZSTD_V}/zstd-${ZSTD_V}.tar.gz
	https://github.com/google/brotli/archive/refs/tags/v${BROTLI_V}.tar.gz -> brotli-${BROTLI_V}.tar.gz
	https://github.com/google/boringssl/archive/${BORINGSSL_SHA}.zip -> boringssl-${BORINGSSL_SHA}.zip
	https://github.com/nghttp2/nghttp2/releases/download/v${NGHTTP2_V}/nghttp2-${NGHTTP2_V}.tar.bz2
	https://github.com/ngtcp2/ngtcp2/releases/download/v${NGTCP2_V}/ngtcp2-${NGTCP2_V}.tar.bz2
	https://github.com/ngtcp2/nghttp3/releases/download/v${NGHTTP3_V}/nghttp3-${NGHTTP3_V}.tar.bz2
	https://github.com/curl/curl/archive/${CURL_V}.tar.gz -> ${CURL_V//_/.}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="clients static-libs"

# All heavy dependencies are bundled by the upstream CMake superbuild.
RDEPEND=""
BDEPEND="dev-build/cmake
	dev-build/ninja"

DOCS=( README.md )

src_prepare() {
	# Point the CMake superbuild at Portage's distfiles so it does not
	# download dependencies during the build (which would break the sandbox).
	sed -i \
		-e "s|URL \"\\\${ZLIB_URL}\"|URL \"file://${DISTDIR}/zlib-${ZLIB_V}.tar.gz\"|" \
		-e "s|URL \"\\\${ZSTD_URL}\"|URL \"file://${DISTDIR}/zstd-${ZSTD_V}.tar.gz\"|" \
		-e "s|URL \"\\\${BROTLI_URL}\"|URL \"file://${DISTDIR}/brotli-${BROTLI_V}.tar.gz\"|" \
		-e "s|URL \"\\\${BORINGSSL_URL}\"|URL \"file://${DISTDIR}/boringssl-${BORINGSSL_SHA}.zip\"|" \
		-e "s|URL \"\\\${NGHTTP2_URL}\"|URL \"file://${DISTDIR}/nghttp2-${NGHTTP2_V}.tar.bz2\"|" \
		-e "s|URL \"\\\${NGTCP2_URL}\"|URL \"file://${DISTDIR}/ngtcp2-${NGTCP2_V}.tar.bz2\"|" \
		-e "s|URL \"\\\${NGHTTP3_URL}\"|URL \"file://${DISTDIR}/nghttp3-${NGHTTP3_V}.tar.bz2\"|" \
		-e "s|URL \"\\\${CURL_URL}\"|URL \"file://${DISTDIR}/${CURL_V//_/.}.tar.gz\"|" \
		CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_LIBIDN2=OFF
		-DCURL_CA_BUNDLE="${EPREFIX}/etc/ssl/certs/ca-certificates.crt"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Upstream installs dependency licenses to CMAKE_INSTALL_PREFIX root.
	# Relocate them to the doc directory.
	local f
	for f in "${ED}/usr"/LICENSE*; do
		[[ -f "${f}" ]] || continue
		docinto .
		dodoc "${f}"
		rm -f "${f}" || die
	done

	if ! use clients; then
		rm -f "${ED}/usr/bin/curl_"* || die
	fi

	if ! use static-libs; then
		rm -f "${ED}/usr/$(get_libdir)/libcurl-impersonate.a" || die
	fi

	# Avoid conflicting with the system curl headers.
	rm -rf "${ED}/usr/include" || die
}
