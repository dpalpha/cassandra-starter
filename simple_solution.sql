
                    

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
AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.SnappyCompressor'};

                

INSERT INTO time_read_logs (userId, companyId, readData) VALUES (uuid(), 1, toUnixTimestamp(now()));
INSERT INTO time_read_logs (userId, companyId, readData) VALUES (uuid(), 1, toUnixTimestamp(now()));
INSERT INTO time_read_logs (userId, companyId, readData) VALUES (uuid(), 1, toUnixTimestamp(now()));
INSERT INTO time_read_logs (userId, companyId, readData) VALUES (uuid(), 1, toUnixTimestamp(now()));
INSERT INTO time_read_logs (userId, companyId, readData) VALUES (uuid(), 1, toUnixTimestamp(now()));
INSERT INTO time_read_logs (userId, companyId, readData) VALUES (uuid(), 1, toUnixTimestamp(now()));






CREATE TYPE IF NOT EXISTS changes (x0 timestamp ,x1 text, x2 int);
CREATE TABLE IF NOT EXISTS changes_logs (
    modUserId uuid, 
    modCompanyId int,
    modChange map<text, frozen <changes>>,
    numChange tuple<int, text>,
    PRIMARY KEY ((modUserId), numChange))
WITH comment = ''
AND caching = {'keys':'ALL', 'rows_per_partition':'NONE'}
AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.SnappyCompressor'};

                

INSERT INTO changes_logs (modUserId, modCompanyId, modChange, numChange) 
VALUES (uuid(), 1, {'name': {x0: toUnixTimestamp(now()), x1: 'ijoijit', x2: 4}}, (3, 'SSA'));

INSERT INTO changes_logs (modUserId, modCompanyId, modChange, numChange) 
VALUES (uuid(), 1, {'name': {x0: toUnixTimestamp(now()), x1: 'ijoijit', x2: 4}}, (3, 'SAD'));


INSERT INTO changes_logs (modUserId, modCompanyId, modChange, numChange) 
VALUES (uuid(), 1, {'name': {x0: toUnixTimestamp(now()), x1: 'ijoijit', x2: 4}}, (3, 'ADS'));
