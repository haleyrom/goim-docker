# goim-docker

A [goim v2](https://github.com/Terry-mao/goim) image on docker.Using CentOS as the base image.

### Usage
First,pull the image:

```
$ docker pull haleyrom/goim-docker 
```  
Then create a container using the image:
```
$ docker run -d \
    -p 3101:3101 \
    -p 3102:3102 \
    -p 3103:3103 \
    -p 3111:3111 \
    -p 3119:3119 \
    -p 6379:6379 \
    -p 7172:7172 \
    -p 9092:9092 \
	haleyrom/goim-docker
```   
Or,you can use Docker Compose as well.See `docker-compose.yml`

### Volume Settings:
`/root/config` contains the config files for router,logic,comet,job and client.  
`/root/logs` contains the log files for router,logic,comet,job,zookeeper and kafka.  
`/root/soft/example` is the folder of goim examples.

**Container startup failed.Here's the reason and solution:**  
The starting script of the image uses `sleep 5;` statement to keep the startup order of the programs.  
If your computer,for example,cannot start Apache Zookeeper in 5 seconds,will cause the container fail to start.  
To solve the problem,simply run the container in the interactive mode,and then modify the startup script manually. 
