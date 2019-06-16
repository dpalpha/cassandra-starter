
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


