FROM quay.io/centos/centos:7

RUN yum install -y \
        gcc \
        make \
        unzip \
        wget \
        glib2-devel \
        cairo-gobject-devel \
        gobject-introspection-devel \
        centos-release-scl

RUN yum install -y \
        rh-python38 \
        rh-python38-python-devel

ENV PATH=/opt/rh/rh-python38/root/usr/local/bin:/opt/rh/rh-python38/root/usr/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/rh/rh-python38/root/usr/lib64
ENV MANPATH=/opt/rh/rh-python38/root/usr/share/man
ENV PKG_CONFIG_PATH=/opt/rh/rh-python38/root/usr/lib64/pkgconfig:/usr/local/lib64/pkgconfig
ENV XDG_DATA_DIRS=/opt/rh/rh-python38/root/usr/share:/usr/local/share:/usr/share

RUN pip3 install meson pygobject pyinstaller pyclip requests

WORKDIR /build

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip && \
    unzip ninja-linux.zip && \
    cp ninja /usr/local/bin && \
    chmod +x /usr/local/bin/ninja

RUN wget https://github.com/upx/upx/releases/download/v3.96/upx-3.96-amd64_linux.tar.xz && \
    tar -xf upx-3.96-amd64_linux.tar.xz && \
    cp upx-3.96-amd64_linux/upx /usr/local/bin && \
    chmod +x /usr/local/bin/upx

RUN echo /usr/local/lib64 >> /etc/ld.so.conf

COPY libglibutil libglibutil
RUN meson --buildtype release _libglibutil libglibutil
RUN meson install -C _libglibutil

COPY libgbinder libgbinder
RUN meson --buildtype release _libgbinder libgbinder
RUN meson install -C _libgbinder

COPY gbinder-python gbinder-python
RUN pip3 install ./gbinder-python
