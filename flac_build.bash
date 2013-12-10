pushd $IDZ_BUILD_ROOT

IDZ_FW_NAME=FLAC
IDZ_NAME=flac
IDZ_LIB_VERSION=1.2.1

# IDZ_ARCHIVE_SUFFIX the suffix of the archive to be downloaded without the 
# first period. Usually zip or tar.gz
IDZ_ARCHIVE_SUFFIX=tar.gz

IDZ_LIB=lib$IDZ_NAME
IDZ_LIB_ALL=$IDZ_LIB.a

# IDZ_LIB_DIR the name of the directory created by expanding the archive
IDZ_LIB_DIR=$IDZ_NAME-$IDZ_LIB_VERSION

# IDZ_URL url to download from
IDZ_URL=http://downloads.sourceforge.net/project/flac/flac-src/$IDZ_LIB_DIR-src/$IDZ_LIB_DIR.tar.gz

mkdir -p $IDZ_LIB/$IDZ_LIB_VERSION
pushd $IDZ_LIB/$IDZ_LIB_VERSION

curl -L -O  $IDZ_URL
tar xvfz $IDZ_LIB_DIR.$IDZ_ARCHIVE_SUFFIX

# The install portion of the make process looks for stuff in the build tree that
# is never copied there!
DIRS="build-iPhoneSimulator-i386/doc/html \
build-iPhoneSimulator-x86_64/doc/html \
build-iPhoneOS-armv7/doc/html \
build-iPhoneOS-armv7s/doc/html \
build-iPhoneOS-arm64/doc/html"

for d in $DIRS; do
mkdir -p $d
pushd $d
cp -r ../../../flac-1.2.1/doc/html/api .
popd
done

# Phone builds
export IDZ_EXTRA_CONFIGURE_FLAGS=--with-ogg="$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneOS-armv7 --disable-asm-optimizations"
idz_configure armv7 7.0 $IDZ_LIB_DIR/configure
export IDZ_EXTRA_CONFIGURE_FLAGS="-with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneOS-armv7s --disable-asm-optimizations"
idz_configure armv7s 7.0 $IDZ_LIB_DIR/configure
export IDZ_EXTRA_CONFIGURE_FLAGS="--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneOS-arm64 --disable-asm-optimizations"
idz_configure arm64 7.0 $IDZ_LIB_DIR/configure

# Simulator build
export IDZ_EXTRA_CONFIGURE_FLAGS="--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneSimulator-i386 --disable-asm-optimizations"
idz_configure i386 7.0 $IDZ_LIB_DIR/configure

export IDZ_EXTRA_CONFIGURE_FLAGS="--with-ogg=$IDZ_BUILD_ROOT/libogg/1.3.1/install-iPhoneSimulator-x86_64 --disable-asm-optimizations"
idz_configure x86_64 7.0 $IDZ_LIB_DIR/configure

idz_fw $IDZ_FW_NAME $IDZ_LIB_ALL install-iPhoneSimulator-i386/include/$IDZ_NAME
popd
popd

