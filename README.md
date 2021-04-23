# GLOBAL COVID19 DATABASE

data from [ECDC](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide)

# [MySQL DB](db_mysql.sql)

This database is for an educational purpose. Since the students don't know yet about joining tables, the table **reports** is not normalized and contains the redundant column "continent" for the moment. 

## Tables

**regions**
| name        | continent | population |
| :---------- | :-------- | :--------- |
| Switzerland | Europe    | 8516543    |
| ...         |           |            |

**reports**

| id    | reported_at | cases | deaths | region      | continent |
| :---- | :---------- | :---- | :----- | :---------- | :-------- |
| 15017 | 2020-5-14   | 33    | 3      | Switzerland | Europe    |
| ...   |             |       |        |             |           |

# [MySQL DB Normalized](db_mysql_n.sql)

This is the normalized version of the database. 

## Tables

**regions**
| name        | continent | population |
| :---------- | :-------- | :--------- |
| Switzerland | Europe    | 8516543    |
| ...         |           |            |

**reports**

| id    | reported_at | cases | deaths | region      |
| :---- | :---------- | :---- | :----- | :---------- |  |
| 15017 | 2020-5-14   | 33    | 3      | Switzerland |
| ...   |             |       |        |             |

## Generate the sql
Requirements:

- Ruby (tested with ruby-2.6.2)

run

```sh
ruby to_mysql_db.rb
# or
ruby to_mysql_normalized_db.rb
```