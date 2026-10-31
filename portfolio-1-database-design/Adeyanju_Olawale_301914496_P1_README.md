# Portfolio 1 — Database Design and Modelling

I organised the data into venue, event, ticket_type, purchase, ticket. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| venue | 2 |
| event | 2 |
| ticket_type | 2 |
| purchase | 2 |
| ticket | 3 |

The 45 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Adeyanju_Olawale_301914496_P1_Design.md)
- [ER diagram](Adeyanju_Olawale_301914496_P1_ERDiagram.md)
- [Normalisation](Adeyanju_Olawale_301914496_P1_Normalisation.md)
- [Schema](Adeyanju_Olawale_301914496_P1_Schema.sql)
- [Sample data](Adeyanju_Olawale_301914496_P1_SampleData.sql)
- [Constraint tests](Adeyanju_Olawale_301914496_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Adeyanju_Olawale_301914496_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

