# libtriton_jit Packaging

This directory contains packaging configurations for building Debian (.deb) and RPM packages for libtriton_jit.

## Prerequisites

- Docker
- Docker Buildx (for multi-platform builds)

## Building Debian Packages

### Using the build script

```bash
cd packaging/debian/build-helpers
./build-libtriton-jit.sh \
  --base-image nvidia/cuda:12.4.0-devel-ubuntu22.04 \
  --backend CUDA \
  --output-dir ./output
```

### Manual build

```bash
cd packaging/debian
docker build \
  --build-arg BASE_IMAGE=nvidia/cuda:12.4.0-devel-ubuntu22.04 \
  --build-arg BACKEND=CUDA \
  -f Dockerfile.deb \
  -t libtriton-jit-builder ../../
```

## Building RPM Packages

### Using the build script

```bash
cd packaging/rpm
./build-rpm.sh \
  --base-image nvidia/cuda:12.4.0-devel-rockylinux8 \
  --backend CUDA \
  --output-dir ./output
```

### Manual build

```bash
cd packaging/rpm
docker build \
  --build-arg BASE_IMAGE=nvidia/cuda:12.4.0-devel-rockylinux8 \
  --build-arg BACKEND=CUDA \
  -f Dockerfile.rpm \
  -t libtriton-jit-rpm-builder ../..
```

## Package Contents

### libtriton-jit (Runtime Package)
- `/usr/lib/*/libtriton_jit.so.*` - Shared library
- `/usr/share/triton_jit/scripts/*.py` - Python helper scripts

### libtriton-jit-dev (Development Package)
- `/usr/include/triton_jit/` - Header files
- `/usr/lib/*/libtriton_jit.so` - Development symlink
- `/usr/lib/*/cmake/TritonJIT/` - CMake configuration files

## GitHub Actions

The `.github/workflows/build-deb.yml` and `.github/workflows/build-rpm.yml` workflows automatically build packages on push/PR.
On tag builds, they upload the generated `.deb` and `.rpm` artifacts to the matching GitHub release.

## Dependencies

### Build Dependencies
- CMake >= 3.26
- Ninja build system
- CUDA Toolkit
- Python 3 development files
- PyTorch >= 2.5.0
- Triton >= 3.1.0
- pybind11
- nlohmann-json
- fmt >= 10.2.1

### Runtime Dependencies
- PyTorch
- Triton
- CUDA runtime

## Notes

- The packages are built using external dependencies (nlohmann-json, fmt, pybind11) rather than fetching them during build
- RPATH is removed from the shared libraries during packaging
- Examples are not built in the packages to reduce build time
- Use `--backend` (CUDA, IX, MUSA, NPU) with a matching base image that provides the required SDK/toolkit for that backend
