# Define the base image.
FROM centos:latest
# Set environment variables.
ENV kafka_ver=2.12
ENV kafka_rel=2.6.3
ENV GO111MODULE on
ENV GOPROXY https://goproxy.io,direct
# Create dirs.
RUN cd /root && \
    mkdir src && \
    mkdir soft && \
    mkdir shell && \
    mkdir logs && \
    mkdir go && \
    mkdir /root/go/src
# Add files
ADD shell /root/shell
# Install tools.
RUN yum update -y && \
    yum install -y bash sudo psmisc git go wget java-1.8.0-openjdk hg make && \
    yum clean all && \
# Clone goim
    cd /root/src && \
    git clone https://github.com/Terry-Mao/goim.git && \
# Download&Install Apache Kafka
    cd /root/soft && \
    wget  https://dlcdn.apache.org/kafka/$kafka_rel/kafka_$kafka_ver-$kafka_rel.tgz && \
    tar -xzf kafka_$kafka_ver-$kafka_rel.tgz && \
    rm -rf kafka_$kafka_ver-$kafka_rel.tgz && \
    cd /root/soft && \
    ls && \
    cd /root/soft/kafka_$kafka_ver-$kafka_rel && \
    mkdir /root/config && \
    mv ./config/zookeeper.properties /root/config/ && \
    ln -s /root/config/zookeeper.properties ./config/zookeeper.properties && \
    mv ./config/server.properties /root/config/ && \
    ln -s /root/config/server.properties ./config/server.properties && \
# Download the dependences. \
    go env && \
    cd /root/src && \
    \cp -rf goim /root/go/src/ && \
    cd /root/src/goim && \
    go mod tidy && \
    make build && \
    cd target && \
    ls && \
    mkdir /root/soft/comet && \
    \cp -rf comet /root/soft/comet/ && \
    \cp -rf comet.toml /root/config/comet.toml && \
    mkdir /root/soft/logic && \
    \cp -rf logic /root/soft/logic/ && \
    \cp -rf logic.toml /root/config/logic.toml && \
    mkdir /root/soft/job && \
    \cp -rf logic /root/soft/job/ && \
    \cp -rf logic.toml /root/config/job.toml && \
# Cleaning up
    yum autoremove -y git go wget && \
    rm -rf /root/src && \
    rm -rf /root/go && \
# Permission setting up
    chmod -R 777 /root/shell && \
    ln -s /root/shell/start.sh /root/start.sh && \
    ln -s /root/shell/stop.sh /root/stop.sh

# Volume settings
VOLUME ["/root/logs","/root/config"]

# Port settings
EXPOSE 7171
EXPOSE 3109
EXPOSE 3101
EXPOSE 3102
EXPOSE 3103
EXPOSE 9092
EXPOSE 3119
EXPOSE 3111
EXPOSE 9092
EXPOSE 6379

# Startup command
CMD /bin/bash -c /root/start.sh

