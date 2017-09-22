
FROM ubuntu:14.04

# Disable prompts from apt.
ENV DEBIAN_FRONTEND noninteractive

# Install Java 8 JRE and curl.
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y -q openjdk-8-jre curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Spark
ENV SPARK_VERSION 2.2.0
ENV HADOOP_VERSION 2.7
ENV SPARK_HOME /usr/local/spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
  ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME}

RUN cd "$SPARK_HOME" && \
    rm jars/* && \
    curl -O https://storage.googleapis.com/spark-resources/spark-2.2.0-assembly.tgz && \
    tar xvf spark-2.2.0-assembly.tgz && \
    rm spark-2.2.0-assembly.tgz

RUN apt-get update && apt-get install -y gfortran && apt-get install -y libopenblas-base liblapack-dev

COPY log4j.executor.properties $SPARK_HOME/conf/