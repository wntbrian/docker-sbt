# This Dockerfile has two required ARGs to determine which base image
# to use for the JDK and which sbt version to install.

# ARG OPENJDK_TAG=8u181
FROM openjdk:8u181

ARG SBT_VERSION=1.2.7

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

# Install JCP
ADD ./jcp-2.0.40035 /jcp2

ARG JDK=/usr/lib/jvm/java-8-openjdk-amd64

RUN cd /jcp2 && \
  bash setup_console.sh $JDK -jre $JDK/jre && \
  cp dependencies/* $JDK/jre/lib/ext/ && \
  cp Doc/itextpdf/5.5.5/itextpdf_patched-5.5.5.jar $JDK/jre/lib/ext/
