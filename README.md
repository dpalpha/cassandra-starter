# Cassandra DB - STARTER
![image](https://cassandra.apache.org/assets/img/logo-white.svg)


## install from binaries 
```{bash}
wget http://ftp.man.poznan.pl/apache/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz
tar -tgvz apache-cassandra-3.11.4-bin.tar.gz
tar -vxf apache-cassandra-3.11.4-bin.tar.gz
mv apache-cassandra-3.11.4 cassandra
tree cassandra/bin
```


## install from docker registry 
```{bash}
docker pull cassandra
docker image ls 
docker ps -a
```
### how to run this
```{bash}
docker run -d --name cas1 cassandra
docker exec -it cas1 /bin/bash
```

## work with CQLSH
### create keyspace 

```{bash}
cqlsh "CREATE KEYSPACE ex1 WITH replication ={'class': 'SimpleStrategy', 'replication_factor':1};"

cqlsh "ALTER KEYSPACE ex1 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};"

cqlsh "create KEYSPACE ex2 WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};"

cqlsh "use ex1;"
```

```{bash}

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

```

* the minimum number of Cassandra nodes that must acknowledge a read or write operation before the operation can be considered successful
```{bash}
sqlsh "use ex1;"
cqlsh "consistency ONE"
cqlsh "consistency QUORUM"
```

![image](https://www.baeldung.com/wp-content/uploads/2021/09/CassandraConsistency1-818x1024.png)



### extra setings 
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

### run on python
```{bash}
python3.5 -m venv ENV
source ENV/bin/activate
which pip3
CASS_DRIVER_NO_CYTHON=1 pip3 install cassandra-driver
pip3 install notebook
CLASS_DRIVER_NO_CYTHON=1 pip3 install cassandra-driver
ipython install kernel --user --env ENV
```



```{python}

from cassandra.cluster import Cluster
from cassandra import ConsistencyLevel
from cassandra.query import SimpleStatement

user = "Oracle"
cluster=Cluster(['172.17.0.2'])
session=cluster.connect()
session.default_consistency_level = ConsistencyLevel.LOCAL_QUORUM

session.set_keyspace('ex2')
result_set = session.execute('select * from scores');
for result in result_set:
    print(result.year, ' %s'%result.user)
    
stmt = SimpleStatement("""INSERT INTO scores (user, game, year, month, day, score)
values (%(user)s, 'PW', 2019,6,15,1000) IF NOT EXISTS""", consistency_level=ConsistencyLevel.ONE)

res = session.execute(stmt, {'user': user})
for n in res:
    print(n.applied)
    
ALTER TABLE scores ADD addrs list<frozen<map<text,text>>>;


from cassandra.cluster import Cluster
from cassandra import ConsistencyLevel
from cassandra.query import SimpleStatement
user = "Oracle"
addrs = [{"city":"WAW",
          'woj': 'malrsz',
          'bui': '10'}]
cluster=Cluster(['172.17.0.2'])
session=cluster.connect()
session.default_consistency_level = ConsistencyLevel.LOCAL_QUORUM

session.set_keyspace('ex2')
result_set = session.execute('select * from scores');
for result in result_set:
    print(result.year, ' %s'%result.user)
    
stmt = SimpleStatement("""INSERT INTO scores (user, game, year, month, day, score, addrs)
values (%s, 'PW', 2019,6,15,1000, %s) IF NOT EXISTS""", consistency_level=ConsistencyLevel.ONE)

res = session.execute(stmt, [user, addrs])
res = session.execute("select * from scores where user=%s", [user]);
for i in res:
    addrs = i.addrs[0]
    print(addrs)



import time
from cassandra.cluster import Cluster
from cassandra import ConsistencyLevel
from cassandra.query import SimpleStatement

def my_callback(result):
    start = time.time()
    for res in result:
        after = time.time()-start
        print("RESULT", after*1000, "GOT", res.user)
    
start = time.time()

users = ['a', 'b', 'c', 'd', 'e', 'f']
for user in users:
    res = session.execute_async("select * from scores where user=%s", [user]);
    took = time.time()-start
    res.add_callback(my_callback)
    print('Assync :', took*1000)

```



```{python}
from cassandra.cluster import Cluster
from cassandra import ConsistencyLevel
from cassandra.query import SimpleStatement
from cassandra.cqlengine.management import sync_table
from cassandra.cqlengine.models import Model
from cassandra.cqlengine import columns
import uuid, logging

log = logging.getLogger()
log.setLevel('DEBUG')
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(name)s: %(message)s"))
log.addHandler(handler)


KEYSPACE = "ex1"

def main():
    cluster = Cluster(['172.17.0.2'])
    session = cluster.connect()

    log.info("creating keyspace...")
    session.execute("""
        CREATE KEYSPACE IF NOT EXISTS %s
        WITH replication = { 'class': 'SimpleStrategy', 'replication_factor': '2' }
        """ % KEYSPACE)

    log.info("setting keyspace...")
    session.set_keyspace(KEYSPACE)
    
    # session.default_consistency_level = ConsistencyLevel.LOCAL_QUORUM

    log.info("creating table time_read_logs")
    session.execute("""
                        CREATE TABLE IF NOT EXISTS time_read_logs (
                            userId uuid, 
                            companyId int,
                            readData timestamp, 
                            PRIMARY KEY ((companyId, userId), readData))
                        WITH CLUSTERING ORDER BY (readData DESC) 
                        AND comment = ''
                        AND COMPACTION = {'class': 'TimeWindowCompactionStrategy', 
                                                  'compaction_window_unit': 'DAYS', 
                                                'compaction_window_size': 2}
                        AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
                        AND compression = {'sstable_compression': 
                        'org.apache.cassandra.io.compress.SnappyCompressor'}
        """)
    
    insert_query_tab1 = SimpleStatement("""
        INSERT INTO time_read_logs (userId, companyId, readData)
        VALUES ((uuid(), 1, toUnixTimestamp(now()))) IF NOT EXISTS 
        -- TTL 21427200
        -- 2**31 / (24 hours * 60 minuts * 60 sec * 100 changes/sec) = 2147483648 / (24 * 60 * 60 * 100) = 248.55 days
        """)
        
    
    log.info("creating table changes_logs")
    session.execute("""CREATE TYPE IF NOT EXISTS changes (x0 timestamp ,x1 text, x2 int)""")
    session.execute("""
                        CREATE TABLE IF NOT EXISTS changes_logs (
                            modUserId uuid, 
                            modCompanyId int,
                            modChange map<text, frozen <changes>>,
                            numChange tuple<int, text>,
                            PRIMARY KEY ((modUserId), numChange))
                        WITH comment = ''
                        AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
                        AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.SnappyCompressor'}
        """)
    
    insert_query_tab2 = SimpleStatement("""
        INSERT INTO changes_logs (userId, companyId, readData)
        VALUES (uuid(), 1, {'name': {x0: toUnixTimestamp(now()), x1: 'ijoijit', x2: 4}}, (3, 'SSA')) IF NOT EXISTS 
        """)
    
    for i in range(10):
        log.info("inserting row %d" % i)
        session.execute(insert_query_tab1)
        session.execute(insert_query_tab2)

    auditing1 = session.execute_async("SELECT * FROM time_read_logs")
    log.info("userId\tcompanyId\treadData")
    log.info("---\t----\t----")

    try:
        rows = auditing1.result()
    except Exception:
        log.exception("Error reading rows:")
        return

    for row in rows:
        log.info('\t'.join(row))
    session.execute("DROP TABLE time_read_logs")
    session.execute("DROP TABLE changes_logs")
    session.execute("DROP TYPE changes")
    session.execute("DROP KEYSPACE " + KEYSPACE)

if __name__ == "__main__":
    main()
```

