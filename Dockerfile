
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
ENV SPARK_VERSION 2.2.0-k8s-0.5.0
ENV HADOOP_VERSION 2.7.3
ENV SPARK_HOME /usr/local/spark

RUN cd /usr/local && \
    curl -O https://storage.googleapis.com/spark-resources/spark-2.2.0-k8s-0.5.0-bin-with-hadoop-2.7.3.tgz && \
    tar xf   spark-2.2.0-k8s-0.5.0-bin-with-hadoop-2.7.3.tgz  && \
    ln -s /usr/local/  spark-2.2.0-k8s-0.5.0-bin-with-hadoop-2.7.3 ${SPARK_HOME}

RUN apt-get update && apt-get install -y gfortran && apt-get install -y libopenblas-base liblapack-dev

COPY log4j.executor.properties $SPARK_HOME/conf/