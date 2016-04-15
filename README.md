# tx-isolation-and-deadlocks

### Isolation levels
```
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED (aka non-repeatable);
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

For the whole session
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```
### Show isolation level

##### MySql
```
show variables; -- show all the settings;
SHOW VARIABLES LIKE 'tx_isolation';
select @@session.tx_isolation;
```

##### Postgres
```
SHOW ALL; --Displays all the settings;
SHOW transaction_isolation; OR --select current_setting('transaction_isolation');
```
