# tx isolation and deadlocks

### Isolation levels

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED --(aka non-repeatable);
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

--For the whole session in postgres
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;
--For the whole session in MySql
SET [GLOBAL | SESSION] TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

### Supported isolation levels

##### MySql supports four of them
* READ UNCOMMITTED
* READ COMMITTED --(aka non-repeatable)
* REPEATABLE READ
* SERIALIZABLE

```
MVCC works only with the READ COMMITTED and REPEATABLE READ isolation levels.
READ UNCOMMITTED and SERIALIZABLE is not MVCC compatible.
```

##### Postgres 2 of them
* READ UNCOMMITTED - `You will get READ COMMITTED`
* READ COMMITTED --(aka non-repeatable)
* REPEATABLE READ - `You will get SERIALIZABLE`
* SERIALIZABLE

`http://www.postgresql.org/docs/current/static/mvcc-intro.html`

> MVCC implementations may differ from db to db

### Show isolation level

##### MySql
```sql
show variables; -- show all the settings;
SHOW VARIABLES LIKE 'tx_isolation';
select @@session.tx_isolation;
```

##### Postgres
```sql
SHOW ALL; --Displays all the settings;
SHOW transaction_isolation; --OR select current_setting('transaction_isolation');
```

## READ UNCOMMITTED

#### tx1

```
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- MySql
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- PG
```

```sql
begin;
select * from books;
```

#### tx2

```sql
begin;
select * from books;
update books set name = 'New Book - by tx2' where name = 'Book 1';
```
#### tx1

```sql
select * from books; -- you can see the uncommitted changes
```

## READ COMMITTED

```
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; -- MySql
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED; -- PG
```

#### tx1

```sql
begin;
select * from books;
```

#### tx2

```sql
begin;
select * from books;
update books set name = 'New Book - by tx2' where name = 'Book 1';
```
#### tx1

```sql
select * from books; -- you can't see the uncommitted changes
```

#### tx2

```sql
commit;
```

#### tx1

```sql
select * from books; -- you can see the committed changes
```

> Talk about lost updates and possible solutions :scream:

##### Quiz
* What happens if two TXs updates the same data?
* What happens if one TX updates(and commits) and the 2nd TX updates(and commits) the same data without noticing the changes?

## REPEATABLE READ

```
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- MySql;
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- PG
```

#### tx1

```sql
begin;
select * from books;
```

#### tx2

```sql
begin;
select * from books;
update books set name = 'New Book - by tx2' where name = 'Book 1';
```
#### tx1

```sql
select * from books; -- you can't see the uncommitted changes
```

#### tx2

```sql
commit;
```

#### tx1

```sql
select * from books; -- you can't see the committed changes
```

> Lost updates are possible in MySql with `REPEATABLE READ`
> Lost updates are not possible in Postgres with `REPEATABLE READ`.

##### Quiz
* What happens if two TXs updates the same data?
* What happens if one TX updates(and commits) and the 2nd TX updates(and commits) the same data without noticing the changes?

## SERIALIZABLE

```
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- MySql;
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- PG
```

#### tx1

```sql
begin;
select * from books;
```

#### tx2

```sql
begin;
select * from books;
update books set name = 'New Book - by tx2' where name = 'Book 1';
```
#### tx1

```sql
select * from books; -- you can't see the uncommitted changes
```

#### tx2

```sql
commit;
```

#### tx1

```sql
select * from books; -- you can't see the committed changes
```

> Lost updates are possible in MySql with `REPEATABLE READ`

##### Quiz
* What happens if two TXs updates the same data?
* What happens if one TX updates(and not commits yet) and 2nd TX is trying to read in MySql?
* What happens if one TX updates(and commits) and the 2nd TX updates(and commits) the same data without noticing the changes?

## Explicit Locking  - for update (Write lock)
```
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; -- MySql
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED; -- PG
```

`http://www.postgresql.org/docs/current/static/explicit-locking.html`

#### tx1

```sql
begin;
select * from books;
SELECT * from books where id = 4 for update;
```

#### tx2

```sql
begin;
select * from books;
SELECT * from books where id = 4 for update;
```

## Deadlocks

```
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED; -- MySql
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED; -- PG
```

#### tx1

```sql
begin;
select * from books;
update books set name='Book 1 - tx1' where id = 3;
```

#### tx2

```sql
begin;
select * from books;
update books set name='Book 2 - tx2' where id = 4;
update books set name='Book 1 - tx2' where id = 3;
```

#### tx1

```sql
update books set name='Book 2 - tx1' where id = 4;
```

> DB can detect deadlocks and rollbacks least expensive tx.
