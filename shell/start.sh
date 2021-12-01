#!/bin/bash
echo "Starting Zookeeper"
cd /root/soft/kafka_$kafka_ver-$kafka_rel/bin
nohup ./zookeeper-server-start.sh ../config/zookeeper.properties 2>&1 >> /root/logs/zookeeper.log &
sleep 5
echo "Starting Kafka"
nohup ./kafka-server-start.sh ../config/server.properties 2>&1 >> /root/logs/kafka.log &
sleep 5
echo "Creating Topic"
./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 24 --topic KafkaPushsTopic
cd /root/soft/logic
nohup ./logic -c logic.toml -region=sh -zone=sh001 -deploy.env=dev -weight=10 2>&1 >> /root/logs/logic.log &
sleep 5
echo "Starting comet"
cd /root/soft/comet
nohup ./comet -c comet.toml -region=sh -zone=sh001 -deploy.env=dev -weight=10 -addrs=127.0.0.1 -debug=true  2>&1 >> /root/logs/comet.log &
sleep 5
echo "Starting job"
cd /root/soft/job
nohup sudo ./job -c job.toml  -region=sh -zone=sh001 -deploy.env=dev 2>&1 >> /root/logs/job.log &
sleep 5
while true;
do sleep 1;
done;
