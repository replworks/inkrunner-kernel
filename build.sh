#!/usr/bin/env bash
# Builds vmlinux-arm64 natively on an arm64 Linux host.
# Inputs come from kernel.env; output goes to out/.
set -euo pipefail

cd "$(dirname "$0")"
# shellcheck source=kernel.env
source kernel.env

if [[ "$(uname -m)" != "aarch64" ]]; then
  echo "build.sh must run on an arm64 Linux host (got $(uname -m))" >&2
  exit 1
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

curl -fsSL -o "$work/linux.tar.xz" "$KERNEL_SOURCE_URL"
echo "$KERNEL_SOURCE_SHA256  $work/linux.tar.xz" | sha256sum -c -

mkdir "$work/src"
tar -xf "$work/linux.tar.xz" -C "$work/src" --strip-components=1
cp config-arm64 "$work/src/.config"

make -C "$work/src" ARCH=arm64 olddefconfig
make -C "$work/src" ARCH=arm64 -j"$(nproc)" LOCALVERSION="$KERNEL_LOCALVERSION" Image

mkdir -p out
cp "$work/src/arch/arm64/boot/Image" out/vmlinux-arm64
cp "$work/src/.config" out/config-arm64.resolved
strings out/vmlinux-arm64 | grep -m1 '^Linux version ' | tee out/KERNEL_VERSION
(cd out && sha256sum vmlinux-arm64 config-arm64.resolved > SHA256SUMS)
cat out/SHA256SUMS
