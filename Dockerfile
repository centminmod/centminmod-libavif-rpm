# Dockerfile
FROM almalinux:9

# Install required build tools and codec dependencies.
RUN dnf install -y \
      rpm-build \
      rpmdevtools \
      dnf-plugins-core \
      make \
      gcc \
      gcc-c++ \
      cmake \
      git \
      tar \
      curl \
      libaom-devel \
      dav1d-devel \
      rav1e-devel \
      svt-av1-devel && \
    dnf clean all

# Create the standard rpmbuild directory tree (~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}).
RUN rpmdev-setuptree

WORKDIR /root/rpmbuild

# Copy in your spec file from the repository.
COPY libavif.spec SPECS/

# Download the libavif tarball from GitHub.
RUN curl -L "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.1.1.tar.gz" \
        -o SOURCES/libavif-1.1.1.tar.gz

CMD ["rpmbuild", "-ba", "SPECS/libavif.spec"]
