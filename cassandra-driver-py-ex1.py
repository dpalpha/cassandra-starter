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
