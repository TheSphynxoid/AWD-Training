# job microservice

Spring Boot 3.5 / Java 17 service exposing a REST API for **Job** and **Category**
(one category -> many jobs: `job.category_id -> category.id`), with PostgreSQL and Swagger.

## 1. Create the database
PostgreSQL must be running on `localhost:5432` (user `postgres`, password `postgres` by default).

```bash
createdb -U postgres job_db
psql -U postgres -d job_db -f database/job_db.sql
```
The script creates the `category` and `job` tables and inserts sample data.
Different credentials can be supplied with `JOB_DATABASE_URL`,
`JOB_DATABASE_USERNAME`, and `JOB_DATABASE_PASSWORD`.

## 2. Run
```bash
mvn spring-boot:run
```
- Swagger UI: http://localhost:8082/swagger-ui.html
- OpenAPI JSON: http://localhost:8082/v3/api-docs

`spring.jpa.hibernate.ddl-auto=none`: the SQL script owns the schema. Switch to `update` to let Hibernate manage it.

## Endpoints
| Method | Path | Description |
|---|---|---|
| GET | /api/jobs?available=&categoryId= | List jobs (filters optional, newest first) |
| GET | /api/jobs/{id} | Get one job |
| POST | /api/jobs | Create job |
| PUT | /api/jobs/{id} | Update job |
| PATCH | /api/jobs/{id}/availability?available=false | Open / close a job |
| DELETE | /api/jobs/{id} | Delete job |
| GET | /api/categories | List categories |
| GET | /api/categories/{id} | Get one category |
| GET | /api/categories/{id}/jobs | Jobs of a category |
| POST | /api/categories | Create category |
| PUT | /api/categories/{id} | Update category |
| DELETE | /api/categories/{id} | Delete category (409 if it still has jobs) |

Errors: 400 validation, 404 not found, 409 duplicate category name / category still in use (RFC 7807 JSON).

## Example
```json
POST /api/jobs
{
  "name": "Java Spring Boot Developer",
  "description": "Build microservices with Spring Boot",
  "available": true,
  "date": "2026-09-28",
  "categoryId": 1
}
```

## Tests
`mvn test` runs integration tests on in-memory H2, so PostgreSQL is not needed for tests.
