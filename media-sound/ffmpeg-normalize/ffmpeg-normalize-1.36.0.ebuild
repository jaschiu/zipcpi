# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{9..14} )

inherit distutils-r1

DESCRIPTION="Normalize audio via ffmpeg"
HOMEPAGE="https://github.com/slhck/ffmpeg-normalize"
SRC_URI="https://github.com/slhck/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~*"

RDEPEND="
	>=dev-python/tqdm-4.64.1[${PYTHON_USEDEP}]
	>=dev-python/ffmpeg-progress-yield-1.0.1[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.47.0[${PYTHON_USEDEP}]
	media-video/ffmpeg
"

