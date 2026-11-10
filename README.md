# inkrunner-kernel

An arm64 Linux kernel (`vmlinux-arm64`) for Ink Runner's container isolation, which runs on Apple Containerization.

Each release publishes:

- `vmlinux-arm64`: the uncompressed arm64 kernel image
- `config-arm64.resolved`: the final kernel configuration
- `SHA256SUMS`: checksums for both files

## Build

The kernel is built from the upstream source in `kernel.env` with `config-arm64`. `config-arm64` comes from [apple/containerization](https://github.com/apple/containerization/tree/main/kernel) at the commit recorded in `kernel.env`.

`build.sh` runs on an arm64 Linux host. CI builds every pull request. Pushing a tag builds the kernel and publishes a release under that tag.

Tags follow `<kernel version>-<build number>`, for example `6.18.5-1`.

## License

The scripts and workflow in this repository are licensed under Apache-2.0. `config-arm64` is from apple/containerization, also Apache-2.0. The Linux kernel binaries in releases are licensed under GPL-2.0. Each release links to its exact source tarball and configuration.
