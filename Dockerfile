
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
ENV SPARK_VERSION 2.1.0
ENV HADOOP_VERSION 2.7
ENV SPARK_HOME /usr/local/spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xz -C /usr/local/ && \
  ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME}

RUN cd "$SPARK_HOME" && \
    rm jars/* && \
    curl -O https://storage.googleapis.com/spark-resources/spark-assembly-2.1.0.tgz && \
    tar xvf spark-assembly-2.1.0.tgz && \
    rm spark-assembly-2.1.0.tgz

RUN apt-get update && apt-get install -y gfortran && apt-get install -y libopenblas-base liblapack-dev

RUN echo "log4j.rootCategory=WARN, console" >> /usr/local/spark/conf/log4j.executor.properties
RUN echo "log4j.appender.console=org.apache.log4j.ConsoleAppender" >> /usr/local/spark/conf/log4j.executor.properties
RUN echo "log4j.appender.console.target=System.out" >> /usr/local/spark/conf/log4j.executor.properties
RUN echo "log4j.appender.console.layout=com.jcabi.log.MulticolorLayout" >> /usr/local/spark/conf/log4j.executor.properties
RUN echo "log4j.appender.console.layout.ConversionPattern=%d ${falkonry_installationId} %color{%-5p %30.30c} - %m%n" >> 
RUN echo "log4j.logger.falkonry.tercel=INFO" >> /usr/local/spark/conf/log4j.executor.properties
RUN echo "log4j.logger.org.apache.parquet=ERROR" >> /usr/local/spark/conf/log4j.executor.properties
RUN echo "log4j.logger.parquet=ERROR" >> /usr/local/spark/conf/log4j.executor.properties
