FROM almalinux:9

ENV TERM=xterm-256color
ENV container=docker

# Install required build tools and codec dependencies.
RUN dnf update -y && \
    dnf install -y epel-release && \
    dnf config-manager --set-enabled crb && \
    dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled epel && \
    dnf -y groupinstall "Development tools" && \
    dnf install -y --skip-broken \
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

WORKDIR /root/rpmbuild

# Create the standard rpmbuild directory tree (~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}).
RUN rpmdev-setuptree && mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Copy in your spec file from the repository.
COPY libavif.spec SPECS/

# Download the libavif tarball from GitHub.
RUN curl -L "https://github.com/AOMediaCodec/libavif/archive/refs/tags/v1.1.1.tar.gz" \
        -o SOURCES/libavif-1.1.1.tar.gz

CMD ["rpmbuild", "-ba", "SPECS/libavif.spec"]
