## CASSANDRA - quick starter

### install db 1. way
```{bash}
docker
wget http://ftp.man.poznan.pl/apache/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz

tar -tgvz apache-cassandra-3.11.4-bin.tar.gz
tar -vxf apache-cassandra-3.11.4-bin.tar.gz

mv apache-cassandra-3.11.4 cassandra
tree cassandra/bin
```

### install db 2. way
```{bash}
docker pull cassandra
docker image ls
```

### first run
```{bash}
docker run -d --name cas1 cassandra
docker exec -it cas1 /bin/bash
#docker stop cas1
#docker ps -a
#docker start cas1

```

### first init
```{bash}

cqlsh "CREATE KEYSPACE ex1 WITH replication ={'class': 'SimpleStrategy', 'replication_factor':1};"
cqlsh "use ex1;"

cqlsh "ALTER KEYSPACE ex1 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};"

cqlsh "CREATE TABLE scores
(
  user TEXT,
  game TEXT,
  year INT,
  month INT,
  day INT,
  score INT,
  PRIMARY KEY (user, game, year, month, day)
);"

cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('pcmanus', 'Coup', 2015, 05, 01, 4000);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('jbellis', 'Coup', 2015, 05, 03, 1750);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('yukim', 'Coup', 2015, 05, 03, 2250);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('tjake', 'Coup', 2015, 05, 03, 500);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('jmckenzie', 'Coup', 2015, 06, 01, 2000);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('iamaleksey', 'Coup', 2015, 06, 01, 2500);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('tjake', 'Coup', 2015, 06, 02, 1000);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('pcmanus', 'Coup', 2015, 06, 02, 2000);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('jmanor', 'Coup', 2018, 05, 03, 20);"
cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('cfranken', 'Coup', 2017, 02, 03, 20);"

cqlsh "create KEYSPACE ex2 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

sqlsh "use ex1;"
cqlsh "consistency two"

cqlsh "use ex2;"
cqlsh "CONSISTENCY QUORUM"

```

### some configs
```{bash}

cassandra-stress write n=100000
nodetool flush
docker run -d --name cas2 -e CASSANDRA_SEEDS=172.17.0.2 cassandra


#nodetool cleanup
#nodetool ring
#nodetool ring | grep -i 172.17.0.2 | wc -l
#nodetool ring | grep -i 172.17.0.3 | wc -l
#nodetool ring | grep Normal | wc -l
#nodetool repair -pr
```

### run as ring

```{bash}

docker run -d --name cas2 -e CASSANDRA_SEEDS=172.17.0.2 cassandra

// container cas1
docekr exec -it cas1 /bin/bash

// container cas2
docekr exec -it cas1 /bin/bash

# upser replace insert node to ring

# exit
docker kill cas2
docker rm cas2
```



### integration ipython
```{bash}
python3.5 -m venv ENV
source ENV/bin/activate
which pip3
CASS_DRIVER_NO_CYTHON=1 pip3 install cassandra-driver
pip3 install notebook
CLASS_DRIVER_NO_CYTHON=1 pip3 install cassandra-driver
```
ipython install kernel --user --env ENV
