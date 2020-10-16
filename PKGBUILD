# Maintainer: Michael Schantl <floss (at) schantl (dash) lx (dot) at>
pkgname=backup-util-git
pkgver=0.1.0
pkgrel=1
pkgdesc="Utility for backup up files either directly or using btrfs snapshots"
arch=("any")
license=('unknown')
depends=("btrfs-progs" "curl" "pv")
makedepends=('git')
provides=("${pkgname%-git}")
conflicts=("${pkgname%-git}")
install=${pkgname%-git}.install
source=("${pkgname%-git}::git+https://github.com/michael-slx/${pkgname%-git}.git#main")
noextract=()
md5sums=('SKIP')

pkgver() {
  cd "$srcdir/${pkgname%-git}"
  printf "%s" "$(git describe --long | sed 's/\([^-]*-\)g/r\1/;s/-/./g')"
}

package() {
  cd "$srcdir/${pkgname%-git}"
  ./setup.sh --root "$pkgdir"
}
