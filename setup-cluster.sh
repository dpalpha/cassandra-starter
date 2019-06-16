

docker
wget http://ftp.man.poznan.pl/apache/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz

tar -tgvz apache-cassandra-3.11.4-bin.tar.gz
tar -vxf apache-cassandra-3.11.4-bin.tar.gz

mv apache-cassandra-3.11.4 cassandra

tree cassandra/bin
tree /cassandra/bin
ls cassandra/bin
cd ~
docker pull cassandra
docker img ls
docker img -ls
docker image ls
doker run -name cas1

docker logs -f cas1
vim README.rm
docker ps -a
docker inspect cas1
docker exec -it cas1 /bin/bash

cat /firejail

find "%proc%"
find . "%proc"

docker stop cas1

docker ps -a
docker start cas1

# setup cluster cas1
docker run -d --name cas1 cassandra
docker exec -it cas1 /bin/bash

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
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('jbellis', 'Coup', 2015, 05, 03, 1750);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('yukim', 'Coup', 2015, 05, 03, 2250);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('tjake', 'Coup', 2015, 05, 03, 500);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('jmckenzie', 'Coup', 2015, 06, 01, 2000);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('iamaleksey', 'Coup', 2015, 06, 01, 2500);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('tjake', 'Coup', 2015, 06, 02, 1000);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('pcmanus', 'Coup', 2015, 06, 02, 2000);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('jmanor', 'Coup', 2018, 05, 03, 20);"
"INSERT INTO scores (user, game, year, month, day, score) VALUES ('cfranken', 'Coup', 2017, 02, 03, 20);"

sqlsh "use ex1;"
cqlsh "consistency two"

cqlsh "use ex2;"
cqlsh "CONSISTENCY QUORUM"

docker kill cas2;

docker start cas2;

# warning test
# nodetool removenode '7a43b4dc-fb67-470c-823b-c591650a'
watch -n2 nodetool status

#csqlsh
cqlsh "use ex1;"
cqlsh "select * from scores;"

cqlsh "INSERT INTO scores (user, game, year, month, day, score) VALUES ('cfranken', 'Coup', 2017, 02, 03, 20);"


cassandra-stress write n=100000
nodetool flush


docker run -d --name cas2 -e CASSANDRA_SEEDS=172.17.0.2 cassandra

#
nodetool cleanup
nodetool ring
nodetool ring | grep -i 172.17.0.2 | wc -l
nodetool ring | grep -i 172.17.0.3 | wc -l
nodetool ring | grep Normal | wc -l



# upser replace insert node to ring

docker exec -it cas2 /bin/bash
nodetool decommission

du -sh
du -sh data/

# exit
docker kill cas2
docker rm cas2

docker run -d --name cas2 -e CASSANDRA_SEEDS=172.17.0.2 cassandra

// container cas1
docekr exec -it cas1 /bin/bash

// container cas2
docekr exec -it cas1 /bin/bash

drop keyspace ex1;

consistency one
ALTER KEYSPACE keyspace1 WITH replication = {'class': 'SimpleStrategy', 'replication_factor':2};

select count(*) from keyspace1.standard1;

# nodetool replace

$ nodetool repair -pr


CREATE TABLE measurements(
country text,
city text,
station_id text,
time int,
humidity int,
temp int,
pressure float,
PRIMARY KEY((country, city, station_id), time)
) WITH clustering order by (time desc);

INSERT INTO measurements(country, city, station_id, time, humidity, temp, pressure) VALUE ('PL', 'WAW', 'STPW1', 1,20,30, 30.4)


# ipython
python3.5 -m venv ENV
source ENV/bin/activate
which pip3
CASS_DRIVER_NO_CYTHON=1 pip3 install cassandra-driver
pip3 install notebook
CLASS_DRIVER_NO_CYTHON=1 pip3 install cassandra-driver
ipython install kernel --user --env ENV

