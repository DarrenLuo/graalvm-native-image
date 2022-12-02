FROM debian

ARG GRAALVM_YEAR_VERSION=22
ARG GRAALVM_MAJOR_VERSION=3
ARG GRAALVM_MINOR_VERSION=0
ARG GRAALVM_SUFFIX_VERSION
ARG GRAALVM_ARCHITECTURE=amd64
ARG JAVA_VERSION=17
ARG GRAALVM_VERSION=${GRAALVM_YEAR_VERSION}.${GRAALVM_MAJOR_VERSION}.${GRAALVM_MINOR_VERSION}${GRAALVM_SUFFIX_VERSION}

WORKDIR /usr/lib/jvm

RUN apt update \
    && apt install -y wget build-essential libz-dev zlib1g-dev \
    && wget -q https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java${JAVA_VERSION}-linux-${GRAALVM_ARCHITECTURE}-${GRAALVM_VERSION}.tar.gz\
    && tar -xzf graalvm-ce-java${JAVA_VERSION}-linux-${GRAALVM_ARCHITECTURE}-${GRAALVM_VERSION}.tar.gz \
    && rm -rf graalvm-ce-java${JAVA_VERSION}-linux-${GRAALVM_ARCHITECTURE}-${GRAALVM_VERSION}.tar.gz \
    && apt clean all

ENV JAVA_HOME="/usr/lib/jvm/graalvm-ce-java${JAVA_VERSION}-${GRAALVM_VERSION}"
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN gu install native-image

ENTRYPOINT [ "native-image" ]
CMD [ "--version" ]
