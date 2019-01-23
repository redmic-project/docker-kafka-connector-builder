FROM ubuntu:xenial

LABEL maintainer="info@redmic.es"

ARG GRADLE_VERSION=5.1-0ubuntu1

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		software-properties-common && \
	add-apt-repository ppa:cwchien/gradle && \
	apt-get update && \
	apt-get install --no-install-recommends -y \
		gradle=${GRADLE_VERSION} \
		openjdk-8-jdk \
		maven \
		git && \
    rm -rf /var/lib/apt/lists/*

ARG KAFKA_VERSION=trunk
ARG CONFLUENT_VERSION=v5.0.1

RUN git clone --single-branch --branch ${KAFKA_VERSION} https://github.com/apache/kafka.git && \
	git clone --single-branch --branch ${CONFLUENT_VERSION} https://github.com/confluentinc/common.git

WORKDIR "/kafka"

RUN gradle installAll

WORKDIR "/common"

RUN mvn install

RUN apt-get remove --purge -y \
		software-properties-common \
		gradle \
		openjdk-8-jdk \
		maven \
		git && \
	apt-get autoremove --purge -y && \
	rm -rf /kafka /common
