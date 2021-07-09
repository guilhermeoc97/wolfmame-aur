# Maintainer: Guilherme Oliveira de Carvalho <guilherme.oc97@outlook.com>
# Based on the mame-git PKGBUILD by Daniel Bermond

pkgbase=wolfmame
pkgname=('wolfmame' 'wolfmame-tools')
pkgver=0.233
pkgrel=1
pkgdesc='Port of the popular Multiple Arcade Machine Emulator using SDL with OpenGL support - now optimized for MARP and speedrunning'
url='http://replay.marpirc.net/'
license=('GPL')
arch=('x86_64')
makedepends=('nasm' 'python' 'asio' 'rapidjson' 'glm' 'libxinerama' 'sdl2_ttf'
             'qt5-base' 'lua53' 'libutf8proc' 'pugixml' 'portmidi' 'portaudio' 'flac')
source=(https://github.com/mahlemiut/wolfmame/archive/wolf${pkgver/*./}.tar.gz
        wolfmame.sh
        wolfmame.desktop
        wolfmame.svg)
sha256sums=('442cbf629aae3f3e7cbd7a02f38d8576446f8a682c840562070aa3ff7fc7be6f'
            '454bc344bfe6ee12666ccae4884b77a5a98f2b23df7d78a3dfa475a6322d16f4'
            '72c0664615cfd65f116ffdfb856dd5ea412a17c3bac763c3a4ec40b4648940da'
            '17c442c933d764175e4ce1de50a80c0c2ddd5d733caf09c3cd5e6ba697ac43f4')

prepare() {
    # use system libraries, except for asio
    sed -e 's|\# USE_SYSTEM_LIB|USE_SYSTEM_LIB|g' \
        -e 's|USE_SYSTEM_LIB_ASIO|\# USE_SYSTEM_LIB_ASIO|g' -i wolfmame-wolf${pkgver/*./}/makefile
}

build() {
    export CFLAGS+=' -I/usr/include/lua5.3'
    export CXXFLAGS+=' -I/usr/include/lua5.3'
    
    # hack to force linking to lua 5.3
    mkdir -p lib
    ln -s /usr/lib/liblua5.3.so lib/liblua.so
    export LDFLAGS+=" -L$(pwd)/lib"

    cd wolfmame-wolf${pkgver/*./}
    
    make -j$(nproc) \
        NOWERROR='1' \
        OPTIMIZE='2' \
        TOOLS='1' \
        ARCHOPTS='-flifetime-dse=1'
}

package_wolfmame() {
    depends=('sdl2_ttf' 'qt5-base' 'lua53' 'libutf8proc' 'pugixml' 'portmidi' 'portaudio'
             'flac' 'hicolor-icon-theme')
    provides=('mame')
    conflicts=('mame')
    
    # mame script
    install -D -m755 wolfmame.sh "${pkgdir}/usr/bin/wolfmame"
    
    # binary
    install -D -m755 wolfmame-wolf${pkgver/*./}/mame -t "${pkgdir}/usr/lib/wolfmame"
    
    # extra bits
    install -D -m644 wolfmame-wolf${pkgver/*./}/src/osd/modules/opengl/shader/glsl*.*h -t "${pkgdir}/usr/lib/wolfmame/shader"
    cp -dr --no-preserve='ownership' wolfmame-wolf${pkgver/*./}/{artwork,bgfx,plugins,language,ctrlr,keymaps,hash} "${pkgdir}/usr/lib/wolfmame"
    
    # desktop file and icon
    install -D -m644 wolfmame.desktop -t "${pkgdir}/usr/share/applications"
    install -D -m644 wolfmame.svg -t "${pkgdir}/usr/share/icons/hicolor/scalable/apps"
    
    # documentation
    install -d -m755 "${pkgdir}/usr/share/doc"
    install -D -m644 wolfmame-wolf${pkgver/*./}/docs/man/*.6* -t "${pkgdir}/usr/share/man/man6"
    cp -dr --no-preserve='ownership' wolfmame-wolf${pkgver/*./}/docs "${pkgdir}/usr/share/doc/wolfmame"
    rm -r "${pkgdir}/usr/share/doc/wolfmame/man"
}

package_wolfmame-tools() {
    pkgdesc='Port of the popular Multiple Arcade Machine Emulator using SDL with OpenGL support - now optimized for MARP and speedrunning (tools)'
    depends=('sdl2' 'libutf8proc' 'flac')
    provides=('mame-tools')
    conflicts=('mame-tools')
    
    local _file
    for _file in castool chdman floptool imgtool jedutil ldresample ldverify nltool nlwav pngcmp regrep romcmp \
                 split srcclean testkeys unidasm
    do
        install -D -m755 "wolfmame-wolf${pkgver/*./}/${_file}" -t "${pkgdir}/usr/bin"
    done
    
    mv "${pkgdir}/usr/bin"/{,wolfmame-wolf${pkgver/*./}-}split # fix conflicts
    
    install -D -m644 wolfmame-wolf${pkgver/*./}/docs/man/*.1* -t "${pkgdir}/usr/share/man/man1"
}
