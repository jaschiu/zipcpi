# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_EXT=1
inherit distutils-r1 multilib pypi

DESCRIPTION="Python binding for curl-impersonate fork via cffi."
HOMEPAGE="https://pypi.org/project/curl-cffi/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cli"

RDEPEND="
	>=dev-python/cffi-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/certifi-2024.2.2[${PYTHON_USEDEP}]
	cli? ( dev-python/rich[${PYTHON_USEDEP}] )
	>=net-misc/curl-impersonate-1.0.0
"
DEPEND="
	>=net-misc/curl-impersonate-1.0.0
"

distutils_enable_tests pytest

python_compile() {
	local -x IMPERSONATE_LINK_TYPE=dynamic
	local -x IMPERSONATE_BUILD_DIR="${EPREFIX}/usr/$(get_libdir)"
	distutils-r1_python_compile
}
