OPTIONS (DIRECT=TRUE, ERRORS=1000)

LOAD DATA
BADFILE 'conmon.bad'
DISCARDFILE 'conmon.dsc'


APPEND
INTO TABLE dbax.test1
FIELDS TERMINATED BY ';' 
TRAILING NULLCOLS
(id,data1,data1)